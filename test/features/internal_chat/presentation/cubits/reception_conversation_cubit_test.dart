import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_conversation_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_conversation_page_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_doctor_participant_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_message_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_message_sender_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_sender_type.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/message_delivery_status.dart';
import 'package:medical_erp/features/internal_chat/domain/use_cases/get_chat_conversation_use_case.dart';
import 'package:medical_erp/features/internal_chat/domain/use_cases/mark_chat_read_use_case.dart';
import 'package:medical_erp/features/internal_chat/domain/use_cases/poll_chat_messages_use_case.dart';
import 'package:medical_erp/features/internal_chat/domain/use_cases/send_reception_message_use_case.dart';
import 'package:medical_erp/features/internal_chat/presentation/cubits/reception_conversation/reception_conversation_cubit.dart';
import 'package:medical_erp/features/internal_chat/presentation/cubits/reception_conversation/reception_conversation_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetChatConversationUseCase extends Mock
    implements GetChatConversationUseCase {}

class MockPollChatMessagesUseCase extends Mock
    implements PollChatMessagesUseCase {}

class MockSendReceptionMessageUseCase extends Mock
    implements SendReceptionMessageUseCase {}

class MockMarkChatReadUseCase extends Mock implements MarkChatReadUseCase {}

void main() {
  late MockGetChatConversationUseCase mockGetConv;
  late MockPollChatMessagesUseCase mockPoll;
  late MockSendReceptionMessageUseCase mockSend;
  late MockMarkChatReadUseCase mockMarkRead;

  const tDoctor = ChatDoctorParticipantEntity(id: 2, name: 'د. حسام');
  const tConv = ChatConversationEntity(id: 9, doctor: tDoctor);
  const tMessage = ChatMessageEntity(
    id: 1,
    sender: ChatMessageSenderEntity(type: ChatSenderType.doctor),
    body: 'مرحبا',
    isRead: true,
    createdAt: '2026-09-26T18:00:00.000000Z',
  );

  const tPage = ChatConversationPageEntity(
    chat: tConv,
    messages: [tMessage],
    hasOlder: false,
    totalUnread: 0,
    serverTime: '2026-09-26T18:05:00.000000Z',
  );

  setUp(() {
    mockGetConv = MockGetChatConversationUseCase();
    mockPoll = MockPollChatMessagesUseCase();
    mockSend = MockSendReceptionMessageUseCase();
    mockMarkRead = MockMarkChatReadUseCase();
  });

  group('ReceptionConversationCubit', () {
    blocTest<ReceptionConversationCubit, ReceptionConversationState>(
      'loads initial conversation successfully',
      build: () {
        when(() => mockGetConv(chatId: 9))
            .thenAnswer((_) async => const Right(tPage));
        return ReceptionConversationCubit(
          chatId: 9,
          getChatConversationUseCase: mockGetConv,
          pollChatMessagesUseCase: mockPoll,
          sendReceptionMessageUseCase: mockSend,
          markChatReadUseCase: mockMarkRead,
        );
      },
      act: (cubit) => cubit.loadInitial(),
      expect: () => [
        const ReceptionConversationState(
          status: ReceptionConversationStatus.loading,
        ),
        const ReceptionConversationState(
          status: ReceptionConversationStatus.loaded,
          conversation: tConv,
          messages: [tMessage],
        ),
      ],
    );

    test('sendMessage optimistically adds message and updates on success', () async {
      when(() => mockSend(
            chatId: 9,
            message: 'أهلاً بك',
            clientMessageId: any(named: 'clientMessageId'),
          )).thenAnswer((inv) async {
        final cid = inv.namedArguments[#clientMessageId] as String;
        return Right(ChatMessageEntity(
          id: 100,
          clientMessageId: cid,
          sender: const ChatMessageSenderEntity(type: ChatSenderType.reception),
          body: 'أهلاً بك',
          isRead: false,
          createdAt: '2026-09-26T18:06:00.000000Z',
        ));
      });

      final cubit = ReceptionConversationCubit(
        chatId: 9,
        getChatConversationUseCase: mockGetConv,
        pollChatMessagesUseCase: mockPoll,
        sendReceptionMessageUseCase: mockSend,
        markChatReadUseCase: mockMarkRead,
      );

      await cubit.sendMessage('أهلاً بك');

      expect(cubit.state.messages.length, 1);
      expect(cubit.state.messages.first.id, 100);
      expect(cubit.state.messages.first.deliveryStatus, MessageDeliveryStatus.sent);
      expect(cubit.state.isSending, false);
    });
  });
}
