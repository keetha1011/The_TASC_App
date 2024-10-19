import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.deepPurple.withOpacity(0.9),
    cursorWidth: 8,
    cursorHeight: 20,
    style: TextStyle(
      color: Colors.black.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.deepPurple,
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black87, fontSize: 16),
      filled: true,
      fillColor: Colors.deepPurple.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
          width: 2,
          color: Colors.black12.withOpacity(0.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
          width: 2,
          color: Colors.deepPurple.withAlpha(255),
        ),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
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

ListTile drawerListTiles(BuildContext context, String title,Widget page) {
  return ListTile(
    splashColor: Colors.deepPurple.withOpacity(0.2),
    title: Text(
      title,
      style: const TextStyle(fontSize: 16),
    ),
    onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    },
  );
}