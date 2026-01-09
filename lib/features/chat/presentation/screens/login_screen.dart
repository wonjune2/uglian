import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // 1. 변수명을 'idController'로 변경 (이메일 아님!)
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  static const String _virtualDomain = '@proten.co.kr';

  void _handleLogin() async {
    // 빈 값 방지
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('아이디와 비밀번호를 모두 입력하세요.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
