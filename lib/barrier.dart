import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierWidth; // out of 2 where 2 is the width of the screen
  final barrierHeight; //proportion of the screenheight
  final barrierX;
  final bool isThisBottomBarrier;

  const MyBarrier(
      {super.key,
      this.barrierHeight,
      this.barrierX,
      required this.isThisBottomBarrier,
      this.barrierWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: isThisBottomBarrier
                ? const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
        
      ),
    );
  }
}
