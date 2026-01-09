import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uglian/features/chat/models/chat_message_model.dart';

class ChatRepository {
  // Firestore 인스턴스 (데이터베이스 접근 도구)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. 메시지 스트림 가져오기(실시간 듣기)
  // Stream은 데이터 파이프를 통해 물처럼 계속 흘러오는 것입니다.
  Stream<List<ChatMessageModel>> getMessages() {
    return _firestore
        .collection('messages') // messages라는 방을 찾아서
        .orderBy('createdAt', descending: false) // 날짜순으로 정렬해서
        .snapshots() // 실시간으로 감시한다
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatMessageModel.fromFirestore(doc);
          }).toList();
        });
  }

  // 2. 메시지 보내기 (쓰기)
  Future<void> sendMessage({required String text, required String senderId}) async {
    await _firestore.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});
