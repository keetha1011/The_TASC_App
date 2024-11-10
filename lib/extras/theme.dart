import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme() {
  return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.indigo,
      // fontFamily: GoogleFonts.firaSansCondensed().fontFamily,
      fontFamily: GoogleFonts.cairo().fontFamily,
      brightness: Brightness.dark,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ),
      navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.black, indicatorColor: Colors.indigo),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
      dividerTheme: const DividerThemeData(color: Colors.transparent),
      listTileTheme: const ListTileThemeData(textColor: Colors.white),
      tabBarTheme: const TabBarTheme(
          indicatorColor: Colors.indigo, labelColor: Colors.indigo),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.indigo),
      cardTheme: CardTheme(
        color: Colors.deepPurple.shade900.withOpacity(0.4),
      ),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: Colors.deepPurple.shade900));
}

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.deepPurple,
    fontFamily: GoogleFonts.cairo().fontFamily,
    fontFamilyFallback: const ["Roboto", "Noto Sans"],
    // fontFamily: GoogleFonts.firaSansCondensed().fontFamily,
    brightness: Brightness.dark,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, foregroundColor: Colors.black),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(color: Colors.black),
      ),
      indicatorColor: Colors.deepPurple[200],
      iconTheme: const WidgetStatePropertyAll(
        IconThemeData(color: Colors.black),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(color: Colors.transparent),
    listTileTheme: const ListTileThemeData(textColor: Colors.black),
    tabBarTheme: TabBarTheme(
        indicatorColor: Colors.deepPurple[400],
        labelColor: Colors.deepPurple[400]),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple[200], foregroundColor: Colors.black),
    cardTheme: CardTheme(
      color: Colors.deepPurple.shade200,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.deepPurple.shade200,
    ),
  );
}
