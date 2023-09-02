import 'dart:async';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYAxis = 0;
  double s = 0;
  double time = 0;
  double height = 0;
  double gravity = -4.9;
  double velocity = 3.5; //how strong the jump is
  double initialHeight = birdYAxis;
  bool gameHasStarted = false;
  int highScore = 0;
  // static double barrierXone = 1;
  double birdWidth = 0.25; //out of 2,2 being the entire height of the screen
  double birdHeight = 0.2; //out of 2,2 being the entire width of the screen

  //----creating a barrier little bit further from barrierXone
  // double barrierXtwo = barrierXone + 1.5;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; //out  of 2
  List<List<double>> barrierHeight = [
    //out of 2,2 where 2 is the entire height of the screen
    //topheight,bottomheight
    [0.6, 0.4],
    [0.4, 0.6]
  ];
  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYAxis;
    });
  }

  void startGame() {
    gameHasStarted = true;

    // Initialize barrier positions so that they are initially visible on the screen
  barrierX = [1, 1 + 1.5];
    //we are changing a frame in every 60 milliseconds
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      //this is a displacement formula where y=height and t= time y= -1/2gt^2 +vt
      //at a certain time it goes to maximum height and comes down due to gravity

      // time += 0.04;
      time += 0.01;
      height = -4.9 * time * time + 2.8 * time; //v=2.8
      setState(() {
        birdYAxis = initialHeight - height;
        // barrierXone -= 0.05;
        // barrierXtwo -= 0.05;
      });
      // setState(() {
      //   if (barrierXone < -2) {
      //     barrierXone += 3.5;
      //   } else {
      //     barrierXone -= 0.05;
      //   }
      // });

      // setState(() {
      //   if (barrierXtwo < -2) {
      //     barrierXtwo += 3.5;
      //   } else {
      //     barrierXtwo -= 0.05;
      //   }
      // });
       moveMap();
     
      s = s + 0.1;

      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }
      
     // time += 0.01;

      // //landing bird on ground
      // if (birdYAxis > 1) {
      //   timer.cancel();
      //   gameHasStarted = false;
      // }
    });
  }

  void resetGame() {
    if (s > highScore) {
      highScore = s.toInt();
    }
    s = 0;
    Navigator.pop(context); //dismiss the alert dialog
    setState(() {
      birdYAxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYAxis;
      barrierX = [2, 2 + 1.5];
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  bool birdIsDead() {
    if (birdYAxis < -1 || birdYAxis > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth&&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdYAxis <= -1 + barrierHeight[i][0] ||
              birdYAxis + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (buildContext) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(25),
            backgroundColor: Colors.brown,
            title: Center(
              child: Column(children: [
                const Text(
                  'G A M E  O V E R',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'S C O R E   ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      s.toInt().toString(),
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                )
              ]),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //ontap we are giving this condition because we want to start timer only once instead of having
      //timer started on every jump
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdYAxis,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                      Container(
                        alignment: const Alignment(0, -0.5),
                        child: gameHasStarted
                            ? const Text('')
                            : const Text(
                                "TAP TO PLAY",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                      ),
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        barrierX: barrierX[1],
                      ),
                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        barrierX: barrierX[1],
                      ),
                      MyBarrier(
                        isThisBottomBarrier: false,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        barrierX: barrierX[0],
                      ),
                      MyBarrier(
                        isThisBottomBarrier: true,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        barrierX: barrierX[0],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'S C O R E',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          s.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "BEST",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          highScore.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
