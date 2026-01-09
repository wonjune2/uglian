import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uglian/features/chat/models/chat_message_model.dart';
import 'package:uglian/features/chat/repository/chat_repository.dart';

class ChatNotifier extends StreamNotifier<List<ChatMessageModel>> {
  @override
  Stream<List<ChatMessageModel>> build() {
    // Repository에게 "실시간 방송 틀어줘"라고 요청
    final repository = ref.read(chatRepositoryProvider);
    return repository.getMessages();
  }

  // 메시지 전송 함수
  Future<void> sendMessage(String text) async {
    // 아직 로딩 중이면 아무것도 안 함
    if (state.isLoading) return;

    final repository = ref.read(chatRepositoryProvider);

    // Repository에게 전송 요청 (내 아이디는 일단 고정)
    await repository.sendMessage(text: text, senderId: 'user1');
  }
}

final chatProvider = StreamNotifierProvider<ChatNotifier, List<ChatMessageModel>>(() {
  return ChatNotifier();
});
