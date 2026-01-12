import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uglian/features/chat/repository/auth_repository.dart';

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

    try {
      // 사용자가 입력한 ID에 도메인을 강제로 결합
      final String fullEmail = _idController.text.trim() + _virtualDomain;

      await ref.read(authRepositoryProvider).signIn(fullEmail, _passwordController.text.trim());

      // 성공하면 AuthGate가 알아서 화면을 채팅방으로 전환해줍니다.
    } catch (e) {
      if (!mounted) return;
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: 아이디/비밀번호를 확인하세요.\n($e)')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Proten 메신저',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: '아이디',
                  hintText: '예: wjlee',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('로그인', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
