import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {

   final double birdWidth;
  final double birdHeight;
  final birdY;
   const MyBird({super.key, this.birdY, required this.birdHeight, required this.birdWidth});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        
         alignment: Alignment(0,birdY),
        child: Image.asset("images/bird.png",
         width: MediaQuery.of(context).size.height*birdWidth/2,
          height: MediaQuery.of(context).size.height*3/4*birdHeight/1,
          fit: BoxFit.fill,),
          
      ),
    );
  }
}