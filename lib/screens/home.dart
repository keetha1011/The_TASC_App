import 'package:flutter/material.dart';
import 'package:tasc/extras/reusable.dart';

import '../components/drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    bool themeMode =
        (MediaQuery.of(context).platformBrightness.name == "light");
    return Scaffold(
      appBar: AppBar(
        actions: [feedbackBeggar(context)],
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
      drawer: mainDrawer(context, const Home(), themeMode),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: themeMode
                ? [Colors.deepPurple.shade300.withOpacity(0.6), Colors.white]
                : [
                    Colors.deepPurple.shade900.withOpacity(0.3),
                    Colors.black
                  ],
            center: Alignment.center,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "brick by brick",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: themeMode
                              ? toColor("#fef7ff")
                              : toColor("#141414"),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 12),
                          ]),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.height / 6,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                Image.asset("assets/Images/PeterGriffin.png")),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
