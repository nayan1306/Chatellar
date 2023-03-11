import 'package:chat_stack/main.dart';
import 'package:chat_stack/screens/auth/Login_screen.dart';
import 'package:chat_stack/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

// Splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(0, 0, 0, 0)));
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
              width: mq.width * .5,
              top: mq.height * .15,
              left: mq.width * .24,
              child: Transform.scale(
                scale: 1.5,
                child: Image.asset(
                  'images/coverV4.png',
                  width: 400,
                  height: 400,
                ),
              )),
          Positioned(
              bottom: mq.height * .12,
              width: mq.width * .9,
              height: mq.height * .07,
              left: mq.width * .05,
              child: const Text(
                '🙏',
                textAlign: TextAlign.center,
              )),
          Positioned(
              bottom: mq.height * .09,
              width: mq.width * .9,
              height: mq.height * .07,
              left: mq.width * .05,
              child: const Text(
                "Created by : Nayan Verma",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 168, 168, 168),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }
}
