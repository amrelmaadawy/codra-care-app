import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_service_options_use_case.dart';
import 'service_options_state.dart';

class ServiceOptionsCubit extends Cubit<ServiceOptionsState> {
  final GetServiceOptionsUseCase getServiceOptionsUseCase;
  final int appointmentId;
  Timer? _debounceTimer;

  ServiceOptionsCubit({
    required this.getServiceOptionsUseCase,
    required this.appointmentId,
  }) : super(const ServiceOptionsState());

  Future<void> loadServices({String? query}) async {
    emit(state.copyWith(
      status: ServiceOptionsStatus.loading,
      searchQuery: query ?? '',
    ));

    final result = await getServiceOptionsUseCase(
      appointmentId,
      search: query,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceOptionsStatus.error,
        errorMessage: failure.message,
      )),
      (services) => emit(state.copyWith(
        status: ServiceOptionsStatus.success,
        services: services,
      )),
    );
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      loadServices(query: query);
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
