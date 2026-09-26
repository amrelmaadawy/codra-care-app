enum ChatSenderType {
  doctor,
  reception;

  bool get isDoctor => this == doctor;
  bool get isReception => this == reception;

  static ChatSenderType fromString(String value) {
    if (value.toLowerCase() == 'doctor') {
      return ChatSenderType.doctor;
    }
    return ChatSenderType.reception;
  }
}
