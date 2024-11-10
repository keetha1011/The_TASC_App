import 'package:flutter/material.dart';

import '../components/drawer.dart';
import '../extras/reusable.dart';

class CoreMembersPage extends StatefulWidget {
  const CoreMembersPage({super.key});

  @override
  State<CoreMembersPage> createState() => _CoreMembersPageState();
}

class _CoreMembersPageState extends State<CoreMembersPage> {
  @override
  Widget build(BuildContext context) {
    bool themeMode = MediaQuery.of(context).platformBrightness.name == "light";
    return Scaffold(
      drawer: mainDrawer(context, const CoreMembersPage(), themeMode),
      appBar: AppBar(),
    );
  }
}
