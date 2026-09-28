import 'package:equatable/equatable.dart';
import '../../domain/entities/service_option_entity.dart';

enum ServiceOptionsStatus { initial, loading, success, error }

class ServiceOptionsState extends Equatable {
  final ServiceOptionsStatus status;
  final List<ServiceOptionEntity> services;
  final String? errorMessage;
  final String searchQuery;

  const ServiceOptionsState({
    this.status = ServiceOptionsStatus.initial,
    this.services = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  ServiceOptionsState copyWith({
    ServiceOptionsStatus? status,
    List<ServiceOptionEntity>? services,
    String? errorMessage,
    String? searchQuery,
  }) {
    return ServiceOptionsState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, services, errorMessage, searchQuery];
}
