import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasc/extras/theme.dart';
import 'package:tasc/screens/home.dart';
import 'package:tasc/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasc/firebase_options.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var connectivityResult = await Connectivity().checkConnectivity();
  // if (connectivityResult == ConnectivityResult.none) {
  //   debugPrint("Connection Error");
  //   const SnackBar(
  //     content: Text("Connection Error, Try Again"),
  //   );
  //   return;
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TASC',
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: ThemeMode.system,
        home: user != null ? const Home() : const Login());
  }
}

class UserData {
  String name, email, type;
  UserData({
    required this.name,
    required this.email,
    required this.type,
  });
}
