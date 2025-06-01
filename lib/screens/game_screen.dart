// lib/screens/game_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';
import '../models/player.dart';
import '../widgets/board_tile.dart';
import '../widgets/dice_widget.dart';
import '../widgets/dice_3d.dart';
import 'winner_screen.dart';
import 'package:football_ludo/widgets/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Player player1;
  late Player player2;
  late Player currentPlayer;
  late Player lastPlayer;
  Player? extraPlayer; // to track who triggered extra roll

  int diceRoll = 1;
  bool isFreekickRoll = false;
  bool isPenaltyRoll = false;
  bool isCornerRoll = false;
  bool isExtraRoll = false;
  String half = "1st -HALF";
  int extra = 7;
  int e = 0;
  @override
  void initState() {
    super.initState();
    player1 = Player(name: 'RED', color: Colors.red, logo: 'assets/utd.png');
    player2 = Player(name: 'BLUE', color: Colors.blue, logo: 'assets/che.png');

    currentPlayer = player1;
    lastPlayer = currentPlayer;
  }

  void rollDice() {
    setState(() {
      currentPlayer.work = "PLAY ONNN";
      diceRoll = Random().nextInt(6) + 1;
      int newPos = currentPlayer.position;

      if (isExtraRoll) {
        // ❌ Cancel if opponent reached the same tile
        if ((currentPlayer == player1 && player2.position == purpleTiles[e]) ||
            (currentPlayer == player2 && player1.position == purpleTiles[e])) {
          isExtraRoll = false;
          extra = 7;
          currentPlayer.work = "Extra Roll Cancelled by Opponent!";
          e++;
          currentPlayer = (currentPlayer == player1) ? player2 : player1;
          return;
        }

        // ✅ If it's the extra roll player’s turn
        if (currentPlayer == extraPlayer) {
          extra -= diceRoll;

          if (extra == 0) {
            currentPlayer.addPoints(1);
            currentPlayer.work = "SCORED POINT!";
            isExtraRoll = false;
            e++;
          } else if (extra < 0) {
            currentPlayer.work = "MISSED!";
            isExtraRoll = false;
            e++;
          } else {
            currentPlayer.work = "Need $extra more to score!";
          }

          // Don't move the player — they're locked
          currentPlayer = (currentPlayer == player1) ? player2 : player1;
          return;
        }

        // ✅ If opponent’s turn, let them move normally
      }

      if (isCornerRoll == true) {
        isCornerRoll = false;
        if ([6].contains(diceRoll)) {
          currentPlayer.addPoints(1);
          currentPlayer.work = "GOALLLLL!!!!!!";
        } else {
          currentPlayer.work = "MISSED";
        }
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
        return;
      }

      if (isFreekickRoll == true) {
        isFreekickRoll = false;
        if ([1, 6].contains(diceRoll)) {
          currentPlayer.addPoints(1);
          currentPlayer.work = "GOALLLLL!!!!!!";
        } else {
          currentPlayer.work = "MISSED";
        }
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
        return;
      }

      if (isPenaltyRoll == true) {
        isPenaltyRoll = false;
        if ([1, 3, 6].contains(diceRoll)) {
          currentPlayer.addPoints(1);
          currentPlayer.work = "GOALLLLL!!!!!!";
        } else {
          currentPlayer.work = "MISSED";
        }
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
        return;
      }
      if (90 == purpleTiles[e]) {
        half = "2nd-half";
      }
      newPos = currentPlayer.position + diceRoll;
      int pointe = purpleTiles[e];
      if (newPos >= pointe) {
        print("check point $pointe, pos:$newPos");
        currentPlayer.moveTo(pointe);
        newPos = pointe;
      } else {
        currentPlayer.moveTo(newPos);
      }
      if (blueTiles.contains(newPos)) {
        currentPlayer.addPoints(1);
        currentPlayer.work = "GOALLLLL!!!!!!";
      }
      if (redTiles.contains(newPos) ||
          (currentPlayer.ref % 1 == 0 && currentPlayer.ref != 0.0)) {
        currentPlayer.subPoints(1);
        if (redTiles.contains(newPos)) currentPlayer.work = "RED CARD ||";
      }
      if (yellowTiles.contains(newPos)) {
        currentPlayer.addRef(.5);
        currentPlayer.work = "YELLOW CARD || ";
      }
      if (violetTiles.contains(newPos)) {
        currentPlayer.moveTo(newPos - 2 * diceRoll);
        currentPlayer.work = "OFF SIDE //";
      }
      if (purpleTiles.contains(newPos)) {
        isExtraRoll = true;
        extra = 7;
        extraPlayer = currentPlayer; // ✅ Store who activated it
        currentPlayer.work = "Extra Roll Activated! Need 7!";
        e = purpleTiles.indexOf(newPos);
        return; // Player does NOT move now
      }

      final specialTiles = {
        ...{for (var tile in brownTiles) tile: "\tPENALTY\n1,3,6 to SCORE!!"},
        ...{for (var tile in orangeTiles) tile: "\tFREEKICK\n1/6 to SCORE!!"},
        ...{for (var tile in pinkTiles) tile: "\tCORNER\n6 to SCORE!!"},
      };

      if (specialTiles.containsKey(newPos)) {
        lastPlayer = currentPlayer;
        currentPlayer.work = specialTiles[newPos]!;
        if (brownTiles.contains(newPos)) {
          isPenaltyRoll = true;
        }
        if (orangeTiles.contains(newPos)) {
          isFreekickRoll = true;
        }
        if (pinkTiles.contains(newPos)) {
          isCornerRoll = true;
        }
      } else {
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
        lastPlayer = (currentPlayer == player1) ? player2 : player1;
      }

      if (player1.position == 90 && player2.position == 90) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WinnerScreen(player: currentPlayer),
          ),
        );
        return;
      }
    });
  }

  Widget _buildScoreCard(Player player) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 100,
      height: 150,
      color: Colors.transparent, // Transparent background
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEFFCD9),
            radius: 30,
            child: Image.asset(
              player.logo,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${player.score}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEFFCD9),
            ),
          ),
          Text(
            "${player.ref}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _middleCard() {
    return Container(
      width: 0100,
      height: 150,
      padding: const EdgeInsets.all(12),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            half,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEFFCD9),
            ),
          ),
          const Text(
            "V/S", // replace with your dynamic score if needed
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFFEFFCD9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            "Score:", // replace with your dynamic score if needed
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFEFFCD9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            "Warning",
            style: TextStyle(
              fontSize: 14,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    bool leftToRight = true;

    for (int row = 8; row >= 0; row--) {
      List<Widget> rowTiles = [];
      for (int col = 0; col < 10; col++) {
        int number = row * 10 + col + 1;

        List<Player> playersOnTile = [];
        if (player1.position == number) playersOnTile.add(player1);
        if (player2.position == number) playersOnTile.add(player2);

        rowTiles.add(
          Padding(
            padding: const EdgeInsets.all(1), // small spacing around each tile
            child: BoardTile(
              number: number,
              playersOnTile: playersOnTile,
              borderRadius:
                  8, // add this param to round corners inside BoardTile
            ),
          ),
        );
      }

      if (!leftToRight) {
        rowTiles = rowTiles.reversed.toList();
      }

      tiles.addAll(rowTiles);
      leftToRight = !leftToRight;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("LUDO FOOTBALL GAME"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🖼 Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png', // 🔁 Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Score Cards
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 42.0, vertical: 16),
                child: Container(
                  padding:
                      const EdgeInsets.all(1), // padding inside the big box
                  decoration: BoxDecoration(
                    color: Color(0xFF396859)
                        .withAlpha(128), // semi-transparent white bg
                    borderRadius: BorderRadius.circular(16), // rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildScoreCard(player1),
                      _middleCard(),
                      _buildScoreCard(player2),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Game Board
              SizedBox(
                height: 400, // 36px * 9 rows + padding/spacing
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF396859).withAlpha(128),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: SizedBox(
                      width: 400, // 36px * 10 columns
                      height: 360, // 36px * 9 rows
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            16), // Adjust the radius as needed
                        child: GridView.count(
                          crossAxisCount: 10,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: tiles,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dice Button
              // Replace the existing dice section in your build method with this:

// Dice Section with new design
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row 1: Player Turn and Last Player Work
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Box - Player Turn
                        Expanded(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: currentPlayer.color,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.purple, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                "${currentPlayer.name.toUpperCase()}'S\nTURN",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Right Box - Last Player Work
                        Expanded(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: lastPlayer.color,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.purple, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                lastPlayer.work,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Row 2: Center Dice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple, width: 3),
                          ),
                          child: Dice3DWidget(
                            diceRoll: diceRoll,
                            onRollComplete: (rolledNumber) {
                              print("Dice rolled: $rolledNumber");
                              setState(() {
                                diceRoll = rolledNumber;
                                rollDice(); // game logic here
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
