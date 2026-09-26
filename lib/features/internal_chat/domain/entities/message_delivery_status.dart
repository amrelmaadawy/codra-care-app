enum MessageDeliveryStatus {
  sending,
  sent,
  failed,
  read;

  bool get isSending => this == sending;
  bool get isSent => this == sent;
  bool get isFailed => this == failed;
  bool get isRead => this == read;
}
