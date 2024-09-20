import 'package:flutter/material.dart';
import 'package:tasc/extras/reusable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasc/screens/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () {
            signOut(context);
          },
          child: Text("Sign Out")),
    );
  }
}
