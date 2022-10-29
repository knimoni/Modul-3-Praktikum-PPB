import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'screens/detail.dart';
import 'screens/home.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime app',
      home: AnimatedSplashScreen(splash: '[n]https://images.vexels.com/media/users/3/227600/isolated/preview/7aa2a8a711580c0a96607aa7be7b9e5b-hello-30-cake-topper.png', duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.lightBlue,
      nextScreen: HomePage()),
    );
  }
}
