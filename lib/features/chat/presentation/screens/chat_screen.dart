import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uglian/features/chat/models/chat_message_model.dart';
import 'package:uglian/features/chat/presentation/widgets/message_bubble.dart';
import 'package:uglian/features/chat/providers/chat_provider.dart';
import 'package:uglian/features/chat/repository/auth_repository.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 이제 messages는 그냥 리스트가 아니라 'AsyncValue'입니다.
    // (로딩중인지, 에러인지, 데이터인지 알 수 있는 상태값)
    final AsyncValue<List<ChatMessageModel>> asyncMessage = ref.watch(chatProvider);

    final TextEditingController textController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser;

    final String myId = user?.email?.split('@')[0] ?? '알 수 없음';

    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 채팅방'),
        backgroundColor: Colors.indigo, // 회사 느낌의 차분한 색상
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. 메시지 리스트 영역 (화면의 남은 공간을 모두 차지)
          Expanded(
            child: asyncMessage.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('첫 메시지를 남겨보세요!'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(message: message, isMe: message.senderId == myId);
                  },
                );
              },
              error: (error, stackTrace) => Center(child: Text('에러 발생: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),

          // 2. 입력창 영역 (하단에 고정)
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: SafeArea(
              // 아이폰 노치/하단 바 대응
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          ref.read(chatProvider.notifier).sendMessage(value);
                          textController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.indigo),
                    onPressed: () {
                      if (textController.text.trim().isNotEmpty) {
                        ref.read(chatProvider.notifier).sendMessage(textController.text);
                        textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
