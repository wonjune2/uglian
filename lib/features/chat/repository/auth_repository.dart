import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 현재 로그인 상태 변화 감지 (로그인/로그아웃)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 로그인 함수
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // 로그아웃 함수
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// 레파지토리 Provider (도구 등록)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// 유저 상태 감지 Provider (문지기 역할)
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});
