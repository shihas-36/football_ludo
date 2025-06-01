// lib/widgets/dice_widget.dart

import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int diceRoll;
  final VoidCallback onRoll;
  final String currentPlayerName;

  const DiceWidget({
    super.key,
    required this.diceRoll,
    required this.onRoll,
    required this.currentPlayerName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            );
          },
          child: Image.asset(
            'assets/dice$diceRoll.png',
            key: ValueKey<int>(diceRoll),
            width: 80,
            height: 80,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onRoll,
          child: const Text("Roll Dice"),
        ),
      ],
    );
  }
}
