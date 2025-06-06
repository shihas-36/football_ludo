import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Dice3DWidget extends StatefulWidget {
  final int diceRoll;
  final void Function(int)? onRollComplete;

  const Dice3DWidget({
    super.key,
    required this.diceRoll,
    this.onRollComplete,
  });

  @override
  State<Dice3DWidget> createState() => _Dice3DWidgetState();
}

class _Dice3DWidgetState extends State<Dice3DWidget> {
  final Random random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  Future<void> _playDiceSound() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource('rolling-dice.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void rollDice() {
    if (isRolling) return;

    isRolling = true;
    _playDiceSound();

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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayIndex = isRolling ? currentImageIndex : widget.diceRoll - 1;

    return GestureDetector(
      onTap: rollDice,
      child: Transform.rotate(
        angle: random.nextDouble() * pi,
        child: Image.asset(
          images[displayIndex],
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
