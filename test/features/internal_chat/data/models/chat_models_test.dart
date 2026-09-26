import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/internal_chat/data/models/chat_conversation_model.dart';
import 'package:medical_erp/features/internal_chat/data/models/chat_conversation_page_model.dart';
import 'package:medical_erp/features/internal_chat/data/models/chat_list_result_model.dart';
import 'package:medical_erp/features/internal_chat/data/models/chat_message_model.dart';
import 'package:medical_erp/features/internal_chat/data/models/chat_poll_result_model.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_sender_type.dart';

void main() {
  group('Internal Chat Models JSON Parsing', () {
    test('ChatConversationModel parses canonical JSON correctly', () {
      final json = {
        'id': 9,
        'doctor': {
          'id': 2,
          'name': 'د. حسام',
          'specialization': 'جلدية',
          'photo_url': null,
          'is_active': true,
        },
        'last_message': {
          'preview': 'مرحبا دكتور',
          'sender_type': 'reception',
          'created_at': '2026-09-26T18:00:00.000000Z',
        },
        'unread_count': 3,
        'capabilities': {
          'can_view': true,
          'can_send': true,
        },
      };

      final model = ChatConversationModel.fromJson(json);

      expect(model.id, 9);
      expect(model.doctor.id, 2);
      expect(model.doctor.name, 'د. حسام');
      expect(model.doctor.isActive, true);
      expect(model.lastMessage?.preview, 'مرحبا دكتور');
      expect(model.lastMessage?.senderType, ChatSenderType.reception);
      expect(model.unreadCount, 3);
      expect(model.capabilities.canSend, true);
    });

    test('ChatMessageModel parses canonical message JSON correctly', () {
      final json = {
        'id': 44,
        'client_message_id': '550e8400-e29b-41d4-a716-446655440000',
        'sender': {
          'id': 7,
          'name': 'د. حسام',
          'type': 'doctor',
        },
        'body': 'تمام تم الاستلام',
        'is_read': false,
        'read_at': null,
        'created_at': '2026-09-26T18:05:00.000000Z',
      };

      final model = ChatMessageModel.fromJson(json);

      expect(model.id, 44);
      expect(model.clientMessageId, '550e8400-e29b-41d4-a716-446655440000');
      expect(model.sender.name, 'د. حسام');
      expect(model.sender.type, ChatSenderType.doctor);
      expect(model.body, 'تمام تم الاستلام');
      expect(model.isRead, false);
      expect(model.isDoctor, true);
      expect(model.isReception, false);
    });

    test('ChatConversationPageModel parses full page with messages', () {
      final json = {
        'chat': {
          'id': 9,
          'doctor': {
            'id': 2,
            'name': 'د. حسام',
            'is_active': true,
          },
          'unread_count': 0,
          'capabilities': {'can_view': true, 'can_send': true},
        },
        'messages': [
          {
            'id': 44,
            'sender': {'type': 'reception'},
            'body': 'رسالة تجريبية',
            'is_read': true,
            'created_at': '2026-09-26T18:00:00.000000Z',
          }
        ],
        'page': {
          'next_before_id': 20,
          'has_older': true,
        },
        'total_unread': 0,
        'server_time': '2026-09-26T18:10:00.000000Z',
      };

      final page = ChatConversationPageModel.fromJson(json);

      expect(page.chat.id, 9);
      expect(page.messages.length, 1);
      expect(page.messages.first.body, 'رسالة تجريبية');
      expect(page.nextBeforeId, 20);
      expect(page.hasOlder, true);
    });

    test('ChatPollResultModel parses polling updates', () {
      final json = {
        'messages': [
          {
            'id': 45,
            'sender': {'type': 'doctor'},
            'body': 'رسالة جديدة',
            'is_read': false,
            'created_at': '2026-09-26T18:12:00.000000Z',
          }
        ],
        'has_more': false,
        'last_poll_id': 45,
      };

      final poll = ChatPollResultModel.fromJson(json);

      expect(poll.messages.length, 1);
      expect(poll.messages.first.id, 45);
      expect(poll.hasMore, false);
      expect(poll.lastPollId, 45);
    });

    test('ChatListResultModel parses paginated list meta', () {
      final json = {
        'data': [
          {
            'id': 1,
            'doctor': {'id': 10, 'name': 'د. محمد', 'is_active': true},
            'unread_count': 2,
          }
        ],
        'meta': {
          'current_page': 1,
          'last_page': 2,
          'per_page': 20,
          'total': 25,
          'has_more': true,
        },
        'total_unread': 2,
      };

      final list = ChatListResultModel.fromJson(json);

      expect(list.chats.length, 1);
      expect(list.currentPage, 1);
      expect(list.lastPage, 2);
      expect(list.hasMore, true);
      expect(list.totalUnread, 2);
    });
  });
}
