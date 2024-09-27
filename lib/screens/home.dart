import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:tasc/screens/login.dart';
import 'package:tasc/screens/patents.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.center,
        fanAngle: 180,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.settings),
            fabSize: ExpandableFabSize.large,
            shape: const CircleBorder()),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.regular,
            shape: const CircleBorder()),
        children: [
          FloatingActionButton.small(
              child: const Icon(Icons.clean_hands_rounded), onPressed: () {}),
          FloatingActionButton.small(
              child: const Text("pat"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatentsPage()),
                );
              }),
          FloatingActionButton.small(
              child: const Icon(Icons.account_circle_rounded), onPressed: () {})
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              signOut(context);
            },
            child: const Text("Sign Out"),
          ),
        ),
      ]),
    );
  }
}
