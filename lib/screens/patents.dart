import "package:flutter/material.dart";

class PatentsPage extends StatefulWidget {
  const PatentsPage({super.key});

  @override
  State<PatentsPage> createState() => _PatentsPageState();
}

class _PatentsPageState extends State<PatentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(onPressed: () {}, child: Text("Check prisma")),
          )
        ],
      ),
    );
  }
}