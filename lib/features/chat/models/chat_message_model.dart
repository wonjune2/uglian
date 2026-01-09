import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
  });

  // Firebase 문서(Document)를 우리 모델로 변환하는 공장
  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>; // 데이터를 맵으로 가져옴

    return ChatMessageModel(
      id: doc.id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // 모델 객체 -> JSON으로 변환 (Firebase 에 저장할 때)
  Map<String, dynamic> toJson() {
    return {'text': text, 'senderId': senderId, 'createdAt': createdAt.toIso8601String()};
  }
}
