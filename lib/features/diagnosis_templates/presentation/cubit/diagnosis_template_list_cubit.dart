import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diagnosis_template_entity.dart';
import '../../domain/use_cases/create_diagnosis_template_use_case.dart';
import '../../domain/use_cases/delete_diagnosis_template_use_case.dart';
import '../../domain/use_cases/get_diagnosis_templates_use_case.dart';
import '../../domain/use_cases/update_diagnosis_template_use_case.dart';
import '../../domain/use_cases/use_diagnosis_template_use_case.dart';
import 'diagnosis_template_cubit_helpers.dart';
import 'diagnosis_template_list_state.dart';

class DiagnosisTemplateListCubit extends Cubit<DiagnosisTemplateListState> {
  final GetDiagnosisTemplatesUseCase getTemplatesUseCase;
  final CreateDiagnosisTemplateUseCase createTemplateUseCase;
  final UpdateDiagnosisTemplateUseCase updateTemplateUseCase;
  final DeleteDiagnosisTemplateUseCase deleteTemplateUseCase;
  final UseDiagnosisTemplateUseCase useTemplateUseCase;

  Timer? _searchDebounce;
  String? _currentSearch;
  DiagnosisTemplateFilterChip _currentFilter = DiagnosisTemplateFilterChip.all;

  DiagnosisTemplateListCubit({
    required this.getTemplatesUseCase,
    required this.createTemplateUseCase,
    required this.updateTemplateUseCase,
    required this.deleteTemplateUseCase,
    required this.useTemplateUseCase,
  }) : super(const DiagnosisTemplateListInitial());

  @override
  void emit(DiagnosisTemplateListState state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> loadTemplates({String? search, bool reset = false}) async {
    emit(const DiagnosisTemplateListLoading());

    if (reset) {
      _currentSearch = null;
      _currentFilter = DiagnosisTemplateFilterChip.all;
    } else if (search != null) {
      _currentSearch = search.trim().isEmpty ? null : search.trim();
    }

    final result = await getTemplatesUseCase(search: _currentSearch);
    if (isClosed) return;

    result.fold(
      (failure) => emit(DiagnosisTemplateListError(failure)),
      (paginated) {
        if (paginated.items.isEmpty) {
          emit(DiagnosisTemplateListEmpty(
            searchQuery: _currentSearch,
            selectedFilter: _currentFilter,
          ));
        } else {
          emit(DiagnosisTemplateListLoaded(
            items: paginated.items,
            currentPage: paginated.currentPage,
            lastPage: paginated.lastPage,
            total: paginated.total,
            hasMore: paginated.hasMore,
            searchQuery: _currentSearch,
            selectedFilter: _currentFilter,
          ));
        }
      },
    );
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!isClosed) loadTemplates(search: query);
    });
  }

  void setFilter(DiagnosisTemplateFilterChip filter) {
    _currentFilter = filter;
    final current = state;
    if (current is DiagnosisTemplateListLoaded) {
      emit(current.copyWith(selectedFilter: filter));
    } else if (current is DiagnosisTemplateListEmpty) {
      emit(DiagnosisTemplateListEmpty(
        searchQuery: _currentSearch,
        selectedFilter: filter,
      ));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! DiagnosisTemplateListLoaded || !current.hasMore || current.isFetchingMore) {
      return;
    }

    emit(current.copyWith(isFetchingMore: true));
    final nextPage = current.currentPage + 1;
    final result = await getTemplatesUseCase(page: nextPage, search: current.searchQuery);
    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(isFetchingMore: false)),
      (paginated) {
        final updated = List.of(current.items)..addAll(paginated.items);
        emit(current.copyWith(
          items: updated,
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          total: paginated.total,
          hasMore: paginated.hasMore,
          isFetchingMore: false,
        ));
      },
    );
  }

  Future<Either<Failure, DiagnosisTemplateEntity>> createTemplate({
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) async {
    final result = await createTemplateUseCase(
      title: title,
      chiefComplaint: chiefComplaint,
      diagnosis: diagnosis,
      notes: notes,
    );
    result.fold((_) {}, (created) {
      emit(insertOrUpdateTemplateInState(
        state,
        created,
        isNew: true,
        currentSearch: _currentSearch,
        currentFilter: _currentFilter,
      ));
    });
    return result;
  }

  Future<Either<Failure, DiagnosisTemplateEntity>> updateTemplate({
    required int id,
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) async {
    final result = await updateTemplateUseCase(
      id: id,
      title: title,
      chiefComplaint: chiefComplaint,
      diagnosis: diagnosis,
      notes: notes,
    );
    result.fold((_) {}, (updated) {
      emit(insertOrUpdateTemplateInState(
        state,
        updated,
        isNew: false,
        currentSearch: _currentSearch,
        currentFilter: _currentFilter,
      ));
    });
    return result;
  }

  Future<Either<Failure, DiagnosisTemplateEntity>> duplicateTemplate(
    DiagnosisTemplateEntity template,
    String copySuffix,
  ) {
    return createTemplate(
      title: '${template.title} ($copySuffix)',
      chiefComplaint: template.chiefComplaint,
      diagnosis: template.diagnosis,
      notes: template.notes,
    );
  }

  Future<bool> deleteTemplate(int id) async {
    final result = await deleteTemplateUseCase(id);
    if (isClosed) return false;

    return result.fold(
      (failure) => false,
      (_) {
        final current = state;
        if (current is DiagnosisTemplateListLoaded) {
          emit(removeTemplateFromState(current, id));
        }
        return true;
      },
    );
  }

  Future<void> recordUse(int id) async {
    await useTemplateUseCase(id);
    final current = state;
    if (current is DiagnosisTemplateListLoaded) {
      final index = current.items.indexWhere((e) => e.id == id);
      if (index != -1) {
        final item = current.items[index];
        final list = List<DiagnosisTemplateEntity>.from(current.items);
        list[index] = item.copyWith(usageCount: item.usageCount + 1);
        emit(current.copyWith(items: list));
      }
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
