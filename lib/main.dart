import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/teamselection_screen.dart';
import 'screens/gamemode_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TestGame());
}

class TestGame extends StatelessWidget {
  const TestGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Game',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/mode': (context) => const GameModeScreen(),
        '/game': (context) => const GameScreen(),
        '/select': (context) => const TeamSelectionScreen(),
      },
    );
  }
}
