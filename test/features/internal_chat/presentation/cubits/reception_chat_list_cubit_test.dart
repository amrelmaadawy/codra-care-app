import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/core/services/navigation_badge_service.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_conversation_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_doctor_participant_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/entities/chat_list_result_entity.dart';
import 'package:medical_erp/features/internal_chat/domain/use_cases/get_reception_chats_use_case.dart';
import 'package:medical_erp/features/internal_chat/domain/use_cases/get_reception_unread_count_use_case.dart';
import 'package:medical_erp/features/internal_chat/presentation/cubits/reception_chat_list/reception_chat_list_cubit.dart';
import 'package:medical_erp/features/internal_chat/presentation/cubits/reception_chat_list/reception_chat_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetReceptionChatsUseCase extends Mock
    implements GetReceptionChatsUseCase {}

class MockGetReceptionUnreadCountUseCase extends Mock
    implements GetReceptionUnreadCountUseCase {}

void main() {
  late MockGetReceptionChatsUseCase mockGetChats;
  late MockGetReceptionUnreadCountUseCase mockGetUnread;
  late NavigationBadgeService badgeService;

  const tConversation = ChatConversationEntity(
    id: 1,
    doctor: ChatDoctorParticipantEntity(id: 10, name: 'د. حسام'),
    unreadCount: 3,
  );

  const tListResult = ChatListResultEntity(
    chats: [tConversation],
    currentPage: 1,
    lastPage: 1,
    perPage: 20,
    total: 1,
    hasMore: false,
    totalUnread: 3,
  );

  setUp(() {
    mockGetChats = MockGetReceptionChatsUseCase();
    mockGetUnread = MockGetReceptionUnreadCountUseCase();
    badgeService = NavigationBadgeService();
  });

  group('ReceptionChatListCubit', () {
    blocTest<ReceptionChatListCubit, ReceptionChatListState>(
      'emits [loading, loaded] and updates badge on successful loadChats',
      build: () {
        when(() => mockGetChats(
              search: any(named: 'search'),
              status: any(named: 'status'),
              page: any(named: 'page'),
              perPage: any(named: 'perPage'),
            )).thenAnswer((_) async => const Right(tListResult));
        return ReceptionChatListCubit(
          getReceptionChatsUseCase: mockGetChats,
          getReceptionUnreadCountUseCase: mockGetUnread,
          badgeService: badgeService,
        );
      },
      act: (cubit) => cubit.loadChats(),
      expect: () => [
        const ReceptionChatListState(status: ReceptionChatListStatus.loading),
        const ReceptionChatListState(
          status: ReceptionChatListStatus.loaded,
          chats: [tConversation],
          totalUnread: 3,
        ),
      ],
      verify: (_) {
        expect(badgeService.getBadge('reception_internal_chat'), 3);
      },
    );

    blocTest<ReceptionChatListCubit, ReceptionChatListState>(
      'emits [loading, error] on failure',
      build: () {
        when(() => mockGetChats(
              search: any(named: 'search'),
              status: any(named: 'status'),
              page: any(named: 'page'),
              perPage: any(named: 'perPage'),
            )).thenAnswer((_) async => const Left(ServerFailure(message: 'error')));
        return ReceptionChatListCubit(
          getReceptionChatsUseCase: mockGetChats,
          getReceptionUnreadCountUseCase: mockGetUnread,
          badgeService: badgeService,
        );
      },
      act: (cubit) => cubit.loadChats(),
      expect: () => [
        const ReceptionChatListState(status: ReceptionChatListStatus.loading),
        const ReceptionChatListState(
          status: ReceptionChatListStatus.error,
          errorMessage: 'error',
        ),
      ],
    );

    test('selectChat updates selectedChatId', () {
      final cubit = ReceptionChatListCubit(
        getReceptionChatsUseCase: mockGetChats,
        getReceptionUnreadCountUseCase: mockGetUnread,
        badgeService: badgeService,
      );
      cubit.selectChat(42);
      expect(cubit.state.selectedChatId, 42);
      cubit.selectChat(null);
      expect(cubit.state.selectedChatId, null);
    });
  });
}
