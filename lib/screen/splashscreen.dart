import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fraudetection/api/statecard.dart';

import 'mainscreen.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key, required this.stateCard});
  StateCard stateCard;

  @override
  Widget build(BuildContext context) {
    return
    FlutterSplashScreen.scale(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(4, 23, 102, 1),
          Color.fromRGBO(4, 23, 102, 1),
        ],
      ),
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: SizedBox(
        height: 150,
        child: Image.asset("assets/images/onlyBGemini.png"),
      ),
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(seconds: 5),
      onAnimationEnd: () => debugPrint("On Scale End"),
      nextScreen: HomeScreen(stateCard: stateCard),
    );
  }
}
