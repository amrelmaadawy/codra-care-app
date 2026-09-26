import 'package:equatable/equatable.dart';

class ChatCapabilitiesEntity extends Equatable {
  final bool canView;
  final bool canSend;

  const ChatCapabilitiesEntity({
    this.canView = true,
    this.canSend = true,
  });

  @override
  List<Object?> get props => [canView, canSend];
}
