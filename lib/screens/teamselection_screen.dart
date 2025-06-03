import 'package:flutter/material.dart';
import 'package:football_ludo/interface/pallate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/teams.dart';

class TeamSelectionScreen extends StatefulWidget {
  const TeamSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TeamSelectionScreen> createState() => _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends State<TeamSelectionScreen>
    with SingleTickerProviderStateMixin {
  // Assets and team names
  final List<Team> allTeams = [
    Team(
      name: 'Chelsea',
      logo: 'assets/che.png',
      shortName: 'CHE',
      color: Colors.blue,
    ),
    Team(
      name: 'Manchester United',
      logo: 'assets/utd.png',
      shortName: 'MUN',
      color: Colors.red,
    ),
    Team(
      name: 'arsnal',
      logo: 'assets/ars.png',
      shortName: 'ARS',
      color: Colors.red,
    ),
    Team(
      name: 'manchester city',
      logo: 'assets/cty.png',
      shortName: 'CTY',
      color: Colors.blue,
    ),
    Team(
      name: 'real Madrid',
      logo: 'assets/rma.png',
      shortName: 'RMA',
      color: Colors.white,
    ),
    Team(
      name: 'Barcelona',
      logo: 'assets/bar.png',
      shortName: 'BAR',
      color: Colors.red,
    ),
    // Add more teams...
  ];

  // Track selected team index for home and away teams separately
  int homeTeamIndex = 0;
  int awayTeamIndex = 0;

  // Track whether we are selecting HOME or AWAY team
  bool selectingHomeTeam = true;

  // Animation controller and slide animation for transition between home/away
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset(-1.0, 0.0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onArrowPressed(bool left) {
    setState(() {
      if (selectingHomeTeam) {
        if (left) {
          homeTeamIndex = (homeTeamIndex - 1) % allTeams.length;
          if (homeTeamIndex < 0) homeTeamIndex += allTeams.length;
        } else {
          homeTeamIndex = (homeTeamIndex + 1) % allTeams.length;
        }
      } else {
        if (left) {
          awayTeamIndex = (awayTeamIndex - 1) % allTeams.length;
          if (awayTeamIndex < 0) awayTeamIndex += allTeams.length;
        } else {
          awayTeamIndex = (awayTeamIndex + 1) % allTeams.length;
        }
      }
    });
  }

  void _onChoosePressed() {
    if (selectingHomeTeam) {
      // Slide to AWAY team selection
      _controller.forward().then((_) {
        setState(() {
          selectingHomeTeam = false;
        });
        _controller.reverse();
      });
    } else {
      // Navigate to GameScreen, passing selected team indices
      print(
          'Navigating with arguments: homeTeam=$homeTeamIndex, awayTeam=$awayTeamIndex');
      Navigator.pushNamed(
        context,
        '/game',
        arguments: {
          'homeTeam': allTeams[homeTeamIndex],
          'awayTeam': allTeams[awayTeamIndex],
        },
      );
    }
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Pallate.darkGreen,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Pallate.lightcream,
            offset: Offset(2, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 28, color: Pallate.lightcream),
        onPressed: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              // Top half
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    children: [
                      // Row with Home and Help buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Pallate.lightcream,
                                  offset: const Offset(2, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallate.darkGreen,
                                fixedSize: const Size(72, 72),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding:
                                    EdgeInsets.zero, // required for centering
                                elevation: 5,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // back to home
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 36,
                                  color: Pallate.lightcream,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Pallate.lightcream,
                                  offset: const Offset(2, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallate.darkGreen,
                                fixedSize: const Size(72, 72),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding:
                                    EdgeInsets.zero, // required for centering
                                elevation: 5,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // back to home
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.question_mark_outlined,
                                  size: 36,
                                  color: Pallate.lightcream,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 65),

                      // Centered HOME TEAM / AWAY TEAM text
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Pallate.darkGreen,
                          borderRadius:
                              BorderRadius.circular(24), // <-- move here
                          // Optional: add a border
                          // border: Border.all(color: Pallate.lightcream, width: 2),
                        ),
                        child: Text(
                          selectingHomeTeam ? 'HOME TEAM' : 'AWAY TEAM',
                          style: GoogleFonts.nunito(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Pallate.lightcream,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 3,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150),

              // Bottom half
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Choose Button
                      ElevatedButton(
                        onPressed: _onChoosePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallate.lightcream,
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 7,
                        ),
                        child: Text(
                          'CHOOSE',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 32,
                            color: Pallate.darkGreen,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Row with trophy and person buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Pallate.lightcream,
                                  offset: const Offset(2, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallate.darkGreen,
                                fixedSize: const Size(72, 72),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding:
                                    EdgeInsets.zero, // required for centering
                                elevation: 5,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // back to home
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.emoji_events_outlined,
                                  size: 36,
                                  color: Pallate.lightcream,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Pallate.lightcream,
                                  offset: const Offset(2, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallate.darkGreen,
                                fixedSize: const Size(72, 72),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding:
                                    EdgeInsets.zero, // required for centering
                                elevation: 5,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // back to home
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.person_3_outlined,
                                  size: 36,
                                  color: Pallate.lightcream,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 48), // Reserve space for left arrow
                    Container(
                      width: 250,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Pallate.lightcream,
                        borderRadius: BorderRadius.circular(48),
                        boxShadow: [
                          BoxShadow(
                            color: Pallate.darkGreen,
                            blurRadius: 1,
                            offset: const Offset(6, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 24,
                            left: 24,
                            right: 24,
                            bottom: 72,
                            child: Image.asset(
                              selectingHomeTeam
                                  ? allTeams[homeTeamIndex].logo
                                  : allTeams[awayTeamIndex].logo,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 0,
                            right: 0,
                            child: Text(
                              selectingHomeTeam
                                  ? allTeams[homeTeamIndex].name.toUpperCase()
                                  : allTeams[awayTeamIndex].name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.bebasNeue(
                                fontSize: 36,
                                color: Pallate.darkGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // Reserve space for right arrow
                  ],
                ),

                // Left Arrow (on top)
                Positioned(
                  left:
                      MediaQuery.of(context).size.width / 2 - 250 / 2 - 48 - 24,
                  child: _buildArrowButton(
                      Icons.chevron_left, () => _onArrowPressed(true)),
                ),

                // Right Arrow (on top)
                Positioned(
                  right:
                      MediaQuery.of(context).size.width / 2 - 250 / 2 - 48 - 24,
                  child: _buildArrowButton(
                      Icons.chevron_right, () => _onArrowPressed(false)),
                ),
              ],
            ),
          )

          // Slide animation overlay (for switching between HOME and AWAY team)
          // Using SlideTransition on the entire screen content could be done,
          // but here we are simulating with AnimationController and state changes
        ],
      ),
    );
  }
}
