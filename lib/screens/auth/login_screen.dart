import 'dart:developer';
import 'dart:io';

import 'package:chat_stack/api/apis.dart';
import 'package:chat_stack/helper/dialogues.dart';
import 'package:chat_stack/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handelGoogleButtonclick() {
    // To show progress bar
    Dialogues.showProgressbar(context);
    _signInWithGoogle().then((user) async {
      // To hide porgress bar
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUser Additional info: ${user.additionalUserInfo}');

        if (await APIs.userExists()) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n__signInWithGoogle: $e');
      Dialogues.showSnackbar(
          context, 'Something went wrong (Check internet !)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Login Screen"),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 11, 29, 31),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
              width: mq.width * .5,
              top: mq.height * .15,
              left: mq.width * .21,
              child: Image.asset('images/login_Icon.png')),
          Positioned(
              bottom: mq.height * .19,
              width: mq.width * .9,
              height: mq.height * .07,
              left: mq.width * .05,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 151, 231, 255),
                    shape: const StadiumBorder(),
                    elevation: 1,
                  ),
                  onPressed: () {
                    _handelGoogleButtonclick();
                  },
                  icon: Image.asset(
                    "images/google.png",
                    height: mq.height * .05,
                  ),
                  label: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16),
                          children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ]))))
        ],
      ),
    );
  }
}
