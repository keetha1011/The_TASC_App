import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  signInWithGoogle();
                  // print(FirebaseAuth.instance.currentUser?.uid);
                },
                icon: const Icon(Icons.login_rounded),
                color: Colors.white70,
              ),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout_rounded),
                color: Colors.white70,
              )
            ],
          ),
          Center(
            child: Text(
              "USER ID IS: ${FirebaseAuth.instance.currentUser?.uid}",
              style: const TextStyle(color: Colors.white70),
            ),
          )
        ],
      ),
    );
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
  print("WORKED");
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
