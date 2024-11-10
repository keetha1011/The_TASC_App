import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/members.dart';
import '../screens/patents.dart';
import '../screens/placements.dart';
import '../screens/profile.dart';
import '../screens/publications.dart';
import '../screens/settings.dart';

Drawer mainDrawer(BuildContext context, Widget currentPage, bool themeMode) {
  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 1,
                center: Alignment.topRight,
                colors: themeMode
                    ? [
                        Colors.deepPurple.shade300.withOpacity(0.8),
                        Colors.white.withOpacity(0.4)
                      ]
                    : [
                        Colors.deepPurple.shade900,
                        Colors.black.withOpacity(0.9)
                      ]),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "The TASC app",
              style: TextStyle(
                fontSize: 32,
                // fontFamily: GoogleFonts.cairo().fontFamily,
                fontWeight: FontWeight.w100,
                color: themeMode ? Colors.black87 : Colors.white,
                shadows: const [
                  Shadow(color: Colors.black12, blurRadius: 16),
                ],
              ),
            ),
          ),
        ),
        drawerListTiles(context, "Home", const Home(), currentPage, themeMode),
        drawerListTiles(
            context, "Patents", const PatentsPage(), currentPage, themeMode),
        drawerListTiles(context, "Publications", const PublicationsPage(),
            currentPage, themeMode),
        drawerListTiles(context, "Placements", const PlacementsPage(),
            currentPage, themeMode),
        // drawerListTiles(context, "Users", const UsersPage(), currentPage),
        drawerListTiles(
            context, "Core", const CoreMembersPage(), currentPage, themeMode),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: currentPage.toString() == "ProfilePage"
                ? Colors.deepPurple.shade200.withOpacity(0.4)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: currentPage.toString() == "SettingsPage"
                ? Colors.deepPurple.shade200.withOpacity(0.4)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Settings"),
            textColor: Colors.deepPurple.shade300,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("SignOut"),
            textColor: Colors.red.shade300,
            onTap: () {
              signOut(context);
            },
          ),
        )
      ],
    ),
  );
}

Padding drawerListTiles(BuildContext context, String title, Widget page,
    Widget currentPage, bool themeMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: ListTile(
      tileColor: currentPage.toString() == page.toString()
          ? themeMode
              ? Colors.deepPurple.shade200.withOpacity(0.4)
              : Colors.deepPurple.shade900.withOpacity(0.4)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      splashColor: themeMode
          ? Colors.deepPurple.withOpacity(0.2)
          : Colors.deepPurple.shade900,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
    ),
  );
}
