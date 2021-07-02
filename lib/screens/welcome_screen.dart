import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/teachersmain_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "/welcome";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User currUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      currUser = user;
      print(currUser.email);
      Navigator.pushNamed(context, TeachersMainScreen.id);
    } else {
      print("no user logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    )),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Tangibly',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: const Duration(milliseconds: 80),
                    )
                  ],
                  repeatForever: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              content: "Login",
              color: Colors.blue.shade300,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              content: "Sign up",
              color: Colors.red.shade300,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
