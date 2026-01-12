import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uglian/features/chat/presentation/screens/chat_screen.dart';
import 'package:uglian/features/chat/presentation/screens/login_screen.dart';
import 'package:uglian/features/chat/repository/auth_repository.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 유저 상태를 실시간으로 지켜봄
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // 유저 정보가 있으면(로그인 됨) -> 채팅방으로
        if (user != null) {
          return const ChatScreen();
        } else {
          // 유저 정보가 없으면(로그아웃 됨) -> 로그인 화면으로
          return const LoginScreen();
        }
      },
      error: (e, stacj) => Scaffold(body: Center(child: Text('에러: $e'))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
