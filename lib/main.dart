// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const SnakeLadderGame());
}

class SnakeLadderGame extends StatelessWidget {
  const SnakeLadderGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}
