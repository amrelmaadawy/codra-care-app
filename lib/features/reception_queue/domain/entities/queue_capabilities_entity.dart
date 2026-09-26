import 'package:equatable/equatable.dart';

class QueueCapabilitiesEntity extends Equatable {
  final bool canTogglePresence;
  final bool canSaveVitals;
  final bool canCallDoctor;
  final bool canComplete;
  final bool canCancel;

  const QueueCapabilitiesEntity({
    this.canTogglePresence = false,
    this.canSaveVitals = false,
    this.canCallDoctor = false,
    this.canComplete = false,
    this.canCancel = false,
  });

  @override
  List<Object?> get props => [
    canTogglePresence,
    canSaveVitals,
    canCallDoctor,
    canComplete,
    canCancel,
  ];
}
