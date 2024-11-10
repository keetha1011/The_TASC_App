import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/members.dart';
import '../screens/patents.dart';
import '../screens/placements.dart';
import '../screens/profile.dart';
import '../screens/publications.dart';
import '../screens/settings.dart';
import 'package:flutter/material.dart';

NavigationDrawer mainDrawer(BuildContext context, Widget currentPage, bool themeMode) {
  return NavigationDrawer(
    backgroundColor: themeMode ? Colors.white : Colors.black,
    elevation: 1,
    selectedIndex: _getSelectedIndex(currentPage),
    onDestinationSelected: (index) {
      Navigator.pop(context); // Close the drawer
      switch (index) {
        case 0: // Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
          break;
        case 1: // Patents
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PatentsPage()),
          );
          break;
        case 2: // Publications
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PublicationsPage()),
          );
          break;
        case 3: // Placements
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PlacementsPage()),
          );
          break;
        case 4: // Core
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CoreMembersPage()),
          );
          break;
        case 5: // Profile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
          break;
        case 6: // Settings
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
          break;
        case 7: // Sign Out
          signOut(context);
          break;
      }
    },
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
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "The TASC app",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w100,
              color: themeMode ? Colors.black87 : Colors.white,
              shadows: const [
                Shadow(color: Colors.black12, blurRadius: 16),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      _buildNavigationItem(
        title: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        themeMode: themeMode,
      ),
      _buildNavigationItem(
        title: 'Patents',
        icon: Icons.description_outlined,
        selectedIcon: Icons.description,
        themeMode: themeMode,
      ),
      _buildNavigationItem(
        title: 'Publications',
        icon: Icons.article_outlined,
        selectedIcon: Icons.article,
        themeMode: themeMode,
      ),
      _buildNavigationItem(
        title: 'Placements',
        icon: Icons.work_outline,
        selectedIcon: Icons.work,
        themeMode: themeMode,
      ),
      _buildNavigationItem(
        title: 'Core',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        themeMode: themeMode,
      ),
      const Divider(indent: 16, endIndent: 16),
      _buildNavigationItem(
        title: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        themeMode: themeMode,
      ),
      _buildNavigationItem(
        title: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        themeMode: themeMode,
        textColor: Colors.deepPurple.shade300,
      ),
      _buildNavigationItem(
        title: 'Sign Out',
        icon: Icons.logout_outlined,
        selectedIcon: Icons.logout,
        textColor: Colors.red.shade300,
        themeMode: themeMode,
      ),
    ],
  );
}

NavigationDrawerDestination _buildNavigationItem({
  required String title,
  required IconData icon,
  required IconData selectedIcon,
  Color? textColor,
  required bool themeMode,
}) {
  return NavigationDrawerDestination(
    icon: Icon(
      icon,
      color: textColor ?? (themeMode ? Colors.black87 : Colors.white70),
    ),
    selectedIcon: Icon(
      selectedIcon,
      color: textColor ?? (themeMode ? Colors.black : Colors.white),
    ),
    label: Text(
      title,
      style: TextStyle(
        color: textColor ?? (themeMode ? Colors.black87 : Colors.white),
        fontSize: 16,
      ),
    ),
  );
}

int _getSelectedIndex(Widget currentPage) {
  switch (currentPage.runtimeType.toString()) {
    case 'Home':
      return 0;
    case 'PatentsPage':
      return 1;
    case 'PublicationsPage':
      return 2;
    case 'PlacementsPage':
      return 3;
    case 'CoreMembersPage':
      return 4;
    case 'ProfilePage':
      return 5;
    case 'SettingsPage':
      return 6;
    default:
      return 0;
  }
}