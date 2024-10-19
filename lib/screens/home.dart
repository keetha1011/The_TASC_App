import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:tasc/screens/events.dart';
import 'package:tasc/screens/login.dart';
import 'package:tasc/screens/patents.dart';
import 'package:tasc/screens/placements.dart';
import 'package:tasc/screens/publications.dart';

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
              child: const Icon(Icons.event), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EventsPage()));
          }),
          FloatingActionButton.small(
              child: const Text("pat"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatentsPage()),
                );
              }),
          FloatingActionButton.small(
              child: const Text("pub"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PublicationsPage()),
                );
              }),
          FloatingActionButton.small(
              child: const Text("pla"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlacementsPage()),
                );
              }),
          FloatingActionButton.small(
              child: const Icon(Icons.account_circle_rounded), onPressed: () {})
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Center(child: Text("with great power comes great responsibility", style: TextStyle(fontSize: 18),),),
        const SizedBox(height: 8,),
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
