import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract final class ChatMessageDateUtils {
  static bool shouldShowDate(List<ChatMessageEntity> messages, int index) {
    if (index == 0) return true;
    final current = DateTime.tryParse(messages[index].createdAt)?.toLocal();
    final prev = DateTime.tryParse(messages[index - 1].createdAt)?.toLocal();
    if (current == null || prev == null) return false;
    return current.year != prev.year ||
        current.month != prev.month ||
        current.day != prev.day;
  }

  static bool shouldShowUnread(List<ChatMessageEntity> messages, int index) {
    final msg = messages[index];
    if (!msg.isDoctor || msg.isRead) return false;
    if (index == 0) return true;
    final prev = messages[index - 1];
    return !prev.isDoctor || prev.isRead;
  }

  static String formatDate(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'reception_chat.today'.tr();
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day) {
      return 'reception_chat.yesterday'.tr();
    }
    return DateFormat.yMMMMd().format(dt);
  }

  static String formatTime(String? rawIso) {
    if (rawIso == null || rawIso.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawIso).toLocal();
      final now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat.jm().format(dt);
      }
      return DateFormat.MMMd().format(dt);
    } catch (_) {
      return '';
    }
  }
}
