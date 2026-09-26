import '../../domain/entities/chat_capabilities_entity.dart';

class ChatCapabilitiesModel extends ChatCapabilitiesEntity {
  const ChatCapabilitiesModel({
    super.canView = true,
    super.canSend = true,
  });

  factory ChatCapabilitiesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChatCapabilitiesModel();
    return ChatCapabilitiesModel(
      canView: json['can_view'] == true ||
          json['can_view'] == 1 ||
          json['can_view'] == '1',
      canSend: json['can_send'] == true ||
          json['can_send'] == 1 ||
          json['can_send'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_view': canView,
      'can_send': canSend,
    };
  }
}
