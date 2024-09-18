import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
);

const ButtonStyle imgButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 248, 249, 255)),
  elevation: WidgetStatePropertyAll(4.0),
  textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.blue)),
);
