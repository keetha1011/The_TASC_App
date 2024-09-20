import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasc/extras/reusable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _outStopAnimation;
  late Animation<double> _transparencyAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _outStopAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.2, end: 0.5), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.5, end: 0.3), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.3, end: 0.6), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.6, end: 0.2), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _transparencyAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.4, end: 0.5), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.5, end: 0.4), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.slowMiddle,
      ),
    );

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(children: [
                GestureDetector(
                    onLongPress: () {
                      Vibration.vibrate(duration: 1000);
                      signInWithGoogle();
                    },
                    onDoubleTap: () {
                      signOut();
                    },
                    child: Transform.scale(
                      origin: const Offset(0, 100),
                      scale: 1.78,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            gradient: RadialGradient(
                          tileMode: TileMode.mirror,
                          colors: [
                            toColor("#06000f"),
                            toColor("0f0026"),
                          ],
                          stops: [_outStopAnimation.value, 1],
                        )),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, screenHeight / 2 - 160, 0, 0),
                          child: fadeMeIn(
                              bannerWidget(
                                  "assets/Logo/TASC.png", 817 / 4, 253 / 4),
                              0)),
                      Align(
                        alignment: Alignment.topCenter,
                        child: fadeMeIn(
                            Text(
                              "DEPARTMENT OF AIML\n User is ${FirebaseAuth.instance.currentUser?.email}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.encodeSansCondensed(
                                  fontSize: 14,
                                  color: Light.withOpacity(0.8),
                                  fontWeight: FontWeight.w800),
                            ),
                            200),
                      ),
                    ])),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,
                      screenHeight - _transparencyAnimation.value * 100, 0, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: fadeMeIn(
                        Text(
                          "Long Press To Login\nDouble Tap to Sign Out",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.encodeSansCondensed(
                              fontSize: 14,
                              color: Light.withOpacity(
                                  _transparencyAnimation.value),
                              fontWeight: FontWeight.w800),
                        ),
                        200),
                  ),
                ),
              ]);
            }));
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> signOut() async {
  GoogleSignIn().disconnect();
  GoogleSignIn().signOut();
  FirebaseAuth.instance.signOut();
}
