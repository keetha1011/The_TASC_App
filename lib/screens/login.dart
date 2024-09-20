import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:tasc/extras/reusable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late final MeshGradientController _meshController;
  late AnimationController _controller;
  late Animation<double> _transparencyAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _transparencyAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.4, end: 0.5), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.5, end: 0.4), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _meshController = MeshGradientController(
      points: [
        MeshGradientPoint(
          position: const Offset(
            -1,
            0.2,
          ),
          color: toColor("#030007"),
        ),
        MeshGradientPoint(
          position: const Offset(
            2,
            0.6,
          ),
          color: toColor("#04010A"),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.7,
            0.3,
          ),
          color: toColor("050011"),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.4,
            0.8,
          ),
          color: toColor("#03000A"),
        ),
      ],
      vsync: this,
    );

    _animateGradient();
    _controller.repeat();
  }

  @override
  void dispose() {
    _meshController.dispose();

    super.dispose();
  }

  void _animateGradient() async {
    while (true) {
      await _meshController.animateSequence(
        duration: const Duration(seconds: 4),
        sequences: [
          AnimationSequence(
            pointIndex: 0,
            newPoint: MeshGradientPoint(
              position: Offset(
                Random().nextDouble() * 2 - 0.5,
                Random().nextDouble() * 2 - 0.5,
              ),
              color: _meshController.points.value[0].color,
            ),
            interval: const Interval(
              0,
              0.5,
              curve: Curves.easeInOut,
            ),
          ),
          AnimationSequence(
            pointIndex: 1,
            newPoint: MeshGradientPoint(
              position: Offset(
                Random().nextDouble() * 2 - 0.5,
                Random().nextDouble() * 2 - 0.5,
              ),
              color: _meshController.points.value[1].color,
            ),
            interval: const Interval(
              0.25,
              0.75,
              curve: Curves.easeInOut,
            ),
          ),
          AnimationSequence(
            pointIndex: 2,
            newPoint: MeshGradientPoint(
              position: Offset(
                Random().nextDouble() * 2 - 0.5,
                Random().nextDouble() * 2 - 0.5,
              ),
              color: _meshController.points.value[2].color,
            ),
            interval: const Interval(
              0.5,
              1,
              curve: Curves.easeInOut,
            ),
          ),
          AnimationSequence(
            pointIndex: 3,
            newPoint: MeshGradientPoint(
              position: Offset(
                Random().nextDouble() * 2 - 0.5,
                Random().nextDouble() * 2 - 0.5,
              ),
              color: _meshController.points.value[3].color,
            ),
            interval: const Interval(
              0.75,
              1,
              curve: Curves.easeInOut,
            ),
          ),
        ],
      );
    }
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
                Positioned(
                  width: max(screenHeight, screenWidth),
                  height: max(screenHeight, screenWidth),
                  child: MeshGradient(
                    controller: _meshController,
                    options: MeshGradientOptions(
                      blend: 5,
                      noiseIntensity: 1,
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    Vibration.vibrate(duration: 100);
                    signInWithGoogle();
                  },
                  onDoubleTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Transform.scale(
                    scaleX: 2,
                    scaleY: 2,
                    origin: Offset(0, 90),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(colors: [
                          toColor("060110", opacity: 0.0),
                          toColor("060110", opacity: 0.6),
                          toColor("060110"),
                        ], stops: const [
                          0.35,
                          0.45,
                          0.7
                        ]),
                      ),
                    ),
                  ),
                ),
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
                  padding: EdgeInsets.fromLTRB(
                      0,
                      screenHeight - 10 - _transparencyAnimation.value * 100,
                      0,
                      0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: fadeMeIn(
                        Text(
                          "Long Press To Login",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.encodeSansCondensed(
                              fontSize: 14,
                              color: Light.withOpacity(1),
                              fontWeight: FontWeight.w800),
                        ),
                        400),
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
