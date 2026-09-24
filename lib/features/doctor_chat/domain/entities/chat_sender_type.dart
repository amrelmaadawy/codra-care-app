enum ChatSenderType {
  doctor,
  reception;

  static ChatSenderType fromString(String? value) {
    if (value == null) return ChatSenderType.doctor;
    return switch (value.toLowerCase()) {
      'reception' => ChatSenderType.reception,
      _ => ChatSenderType.doctor,
    };
  }

  String toValue() {
    return switch (this) {
      ChatSenderType.doctor => 'doctor',
      ChatSenderType.reception => 'reception',
    };
  }

  bool get isDoctor => this == ChatSenderType.doctor;
  bool get isReception => this == ChatSenderType.reception;
}
