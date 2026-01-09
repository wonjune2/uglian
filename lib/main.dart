import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uglian/features/chat/presentation/screens/chat_screen.dart';
import 'package:uglian/firebase_options.dart';

void main() async {
  // 4. Flutter 엔진과 위젯들을 확실히 묶어주는 코드 (필수)
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ChatScreen());
  }
}
