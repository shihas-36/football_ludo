import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Dice3DWidget extends StatefulWidget {
  final int diceRoll; // from parent
  final void Function(int)? onRollComplete;

  const Dice3DWidget({
    super.key,
    required this.diceRoll,
    this.onRollComplete,
  });

  @override
  _Dice3DWidgetState createState() => _Dice3DWidgetState();
}

class _Dice3DWidgetState extends State<Dice3DWidget> {
  Random random = Random();
  int currentImageIndex = 0;
  int counter = 1;
  bool isRolling = false;

  List<String> images = [
    'assets/dice1.png',
    'assets/dice2.png',
    'assets/dice3.png',
    'assets/dice4.png',
    'assets/dice5.png',
    'assets/dice6.png',
  ];

  void rollDice() {
    if (isRolling) return; // avoid double rolling

    isRolling = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      counter++;
      setState(() {
        currentImageIndex = random.nextInt(6);
      });

      if (counter >= 13) {
        timer.cancel();
        counter = 1;
        isRolling = false;

        int finalRoll = currentImageIndex + 1;
        widget.onRollComplete?.call(finalRoll);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show rolling animation images if rolling, else show diceRoll from parent
    final displayIndex = isRolling ? currentImageIndex : widget.diceRoll - 1;

    return GestureDetector(
      onTap: rollDice,
      child: Transform.rotate(
        angle: random.nextDouble() * 180,
        child: Image.asset(
          images[displayIndex],
          height: 10,
          width: 10,
        ),
      ),
    );
  }
}
