import '../../domain/entities/diagnosis_template_entity.dart';
import 'diagnosis_template_list_state.dart';

DiagnosisTemplateListState insertOrUpdateTemplateInState(
  DiagnosisTemplateListState current,
  DiagnosisTemplateEntity item, {
  required bool isNew,
  String? currentSearch,
  DiagnosisTemplateFilterChip currentFilter = DiagnosisTemplateFilterChip.all,
}) {
  if (current is DiagnosisTemplateListLoaded) {
    final list = List<DiagnosisTemplateEntity>.from(current.items);
    if (isNew) {
      list.insert(0, item);
      return current.copyWith(items: list, total: current.total + 1);
    } else {
      final idx = list.indexWhere((e) => e.id == item.id);
      if (idx != -1) {
        list[idx] = item;
        return current.copyWith(items: list);
      }
    }
  } else if (current is DiagnosisTemplateListEmpty && isNew) {
    return DiagnosisTemplateListLoaded(
      items: [item],
      currentPage: 1,
      lastPage: 1,
      total: 1,
      searchQuery: currentSearch,
      selectedFilter: currentFilter,
    );
  }
  return current;
}

DiagnosisTemplateListState removeTemplateFromState(
  DiagnosisTemplateListLoaded current,
  int id,
) {
  final updated = current.items.where((e) => e.id != id).toList();
  if (updated.isEmpty) {
    return DiagnosisTemplateListEmpty(
      searchQuery: current.searchQuery,
      selectedFilter: current.selectedFilter,
    );
  }
  return current.copyWith(
    items: updated,
    total: current.total > 0 ? current.total - 1 : 0,
  );
}
