import '../../domain/entities/queue_capabilities_entity.dart';

class QueueCapabilitiesModel extends QueueCapabilitiesEntity {
  const QueueCapabilitiesModel({
    super.canTogglePresence,
    super.canSaveVitals,
    super.canCallDoctor,
    super.canComplete,
    super.canCancel,
  });

  factory QueueCapabilitiesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const QueueCapabilitiesModel();
    return QueueCapabilitiesModel(
      canTogglePresence: json['can_toggle_presence'] as bool? ?? false,
      canSaveVitals: json['can_save_vitals'] as bool? ?? false,
      canCallDoctor: json['can_call_doctor'] as bool? ?? false,
      canComplete: json['can_complete'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_toggle_presence': canTogglePresence,
      'can_save_vitals': canSaveVitals,
      'can_call_doctor': canCallDoctor,
      'can_complete': canComplete,
      'can_cancel': canCancel,
    };
  }
}
