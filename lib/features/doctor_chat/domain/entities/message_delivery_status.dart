enum MessageDeliveryStatus {
  sending,
  sent,
  failed;

  bool get isSending => this == MessageDeliveryStatus.sending;
  bool get isSent => this == MessageDeliveryStatus.sent;
  bool get isFailed => this == MessageDeliveryStatus.failed;
}
