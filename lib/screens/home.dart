import 'package:flutter/material.dart';
import 'package:tasc/extras/reusable.dart';
import 'package:tasc/screens/events.dart';
import 'package:tasc/screens/feedback.dart';
import 'package:tasc/screens/login.dart';
import 'package:tasc/screens/patents.dart';
import 'package:tasc/screens/placements.dart';
import 'package:tasc/screens/profile.dart';
import 'package:tasc/screens/publications.dart';
import 'package:tasc/screens/users.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          feedbackBeggar(context)
        ],
        centerTitle: true,
        title: const Text("Home"),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(color: Colors.transparent),
              ),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1,
                    center: Alignment.topCenter,
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurple.shade50.withOpacity(0.1)
                    ],
                  ),
                  color: Colors.deepPurple.withOpacity(0.2),
                ),
                child: const Center(
                  child: Text(
                    "The TASC app",
                    style: TextStyle(
                        fontSize: 32,
                        // fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        shadows: [
                          Shadow(color: Colors.black12, blurRadius: 16)
                        ]),
                  ),
                ),
              ),
            ),
            drawerListTiles(context, "Patents", const PatentsPage()),
            drawerListTiles(context, "Publications", const PublicationsPage()),
            drawerListTiles(context, "Placements", const PlacementsPage()),
            drawerListTiles(context, "Users", const UsersPage()),
            // drawerListTiles(context, "Events", const EventsPage()),
            const SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 76,
            //   child: DecoratedBox(decoration: BoxDecoration(color: Colors.black)),
            // )
            ListTile(
              title: const Text("Profile"),
              textColor: Colors.deepPurple.shade300,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              title: const Text("SignOut"),
              textColor: Colors.red.shade300,
              onTap: () {
                signOut(context);
              },
            )
          ],
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.deepPurple.shade100,
              Colors.deepPurple.shade50.withOpacity(0.01)
            ],
            center: Alignment.bottomCenter,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "with great power comes great responsibility",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
