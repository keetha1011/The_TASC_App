import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/members.dart';
import '../screens/feedback.dart';
import '../screens/patents.dart';
import '../screens/publications.dart';
import '../screens/placements.dart';
import '../screens/users.dart';
import '../screens/profile.dart';
import '../screens/login.dart';
import '../screens/home.dart';

Color light = toColor("#ffffff");
// Color Dark = toColor("");

toColor(String hexColor, {double opacity = 1}) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16)).withOpacity(opacity);
}

Image bannerWidget(String imageName, double x, double y) {
  return Image.asset(
    imageName,
    fit: BoxFit.contain,
    width: x,
    height: y,
    color: light.withOpacity(0.9),
  );
}

TextField reusableTextField(
  BuildContext context,
  String text,
  IconData icon,
  bool isPasswordType,
  bool isNumerical,
  TextEditingController controller,
) {
  bool themeMode = (MediaQuery.of(context).platformBrightness.name == "light");
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: themeMode
        ? Colors.deepPurple.withOpacity(0.9)
        : Colors.deepPurple.shade100,
    cursorWidth: 8,
    cursorHeight: 32,
    style: TextStyle(
      fontSize: 32,
      color: themeMode
          ? Colors.black.withOpacity(0.9)
          : Colors.white.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: themeMode ? Colors.deepPurple : Colors.indigo,
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: themeMode
            ? Colors.black87.withOpacity(0.4)
            : Colors.white.withOpacity(0.4),
        fontSize: 16,
      ),
      filled: true,
      fillColor: themeMode
          ? Colors.deepPurple.withOpacity(0.05)
          : Colors.deepPurple.shade100.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
          width: 2,
          color: themeMode
              ? Colors.deepPurple.shade500.withOpacity(0.1)
              : Colors.deepPurple.shade500.withOpacity(0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
          width: 2,
          color: themeMode
              ? Colors.deepPurple.withAlpha(255)
              : Colors.deepPurple.shade100,
        ),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : isNumerical
            ? TextInputType.number
            : TextInputType.emailAddress,
  );
}

Image imageWidget(String imageName, double x, double y) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: x,
    height: y,
  );
}

AlertDialog alertMe(BuildContext context, String title, actions, contents) {
  return AlertDialog(
    actions: actions,
    contentPadding: const EdgeInsets.all(20),
    content: contents,
    title: Text(title),
  );
}

fadeMeIn(Widget wid, double delay) {
  return Animate(
    effects: [
      FadeEffect(
        delay: delay.ms,
        begin: 0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
      ),
      const SlideEffect(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 500),
      )
    ],
    child: wid,
  );
}

Container uiButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: 500,
    height: 50,
    margin: const EdgeInsets.fromLTRB(30, 10, 30, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    ),
  );
}


IconButton feedbackBeggar(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FeedbackPage()));
    },
    icon: const Icon(
      Icons.feedback_rounded,
    ),
  );
}

String resolveBracketIssueWhileUploading(String a) {
  return "[${a.split(',').map((e) => e.trim())}]";
}