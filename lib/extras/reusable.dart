import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Color Light = toColor("#e7e3ff");
Color Dark = toColor("012367");

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
    color: Light.withOpacity(0.9),
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Light.withOpacity(0.9),
    cursorWidth: 2,
    cursorHeight: 20,
    style: TextStyle(color: Light.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Light,
      ),
      labelText: text,
      labelStyle: TextStyle(
          color: Light.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          fontSize: 16),
      filled: true,
      fillColor: Light.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(width: 2, color: Light.withAlpha(200))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(width: 2, color: Light.withAlpha(255))),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Image ImageWidget(String imageName, double x, double y) {
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
