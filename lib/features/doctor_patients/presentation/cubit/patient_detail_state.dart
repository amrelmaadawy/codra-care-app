import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_detail_entity.dart';

sealed class PatientDetailState extends Equatable {
  const PatientDetailState();

  @override
  List<Object?> get props => [];
}

class PatientDetailInitial extends PatientDetailState {
  const PatientDetailInitial();
}

class PatientDetailLoading extends PatientDetailState {
  const PatientDetailLoading();
}

class PatientDetailLoaded extends PatientDetailState {
  final PatientDetailEntity detail;

  const PatientDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class PatientDetailError extends PatientDetailState {
  final Failure failure;

  const PatientDetailError(this.failure);

  @override
  List<Object?> get props => [failure];
}
