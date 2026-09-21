import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/prescription_entity.dart';

sealed class PrescriptionDetailState extends Equatable {
  const PrescriptionDetailState();

  @override
  List<Object?> get props => [];
}

class PrescriptionDetailInitial extends PrescriptionDetailState {
  const PrescriptionDetailInitial();
}

class PrescriptionDetailLoading extends PrescriptionDetailState {
  const PrescriptionDetailLoading();
}

class PrescriptionDetailLoaded extends PrescriptionDetailState {
  final PrescriptionEntity prescription;

  const PrescriptionDetailLoaded(this.prescription);

  @override
  List<Object?> get props => [prescription];
}

class PrescriptionDetailError extends PrescriptionDetailState {
  final Failure failure;

  const PrescriptionDetailError(this.failure);

  @override
  List<Object?> get props => [failure];
}

