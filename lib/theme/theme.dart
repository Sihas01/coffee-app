import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xff794028),
    primary: Color(0xff794028),
    secondary: Color(0xffA66E56),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xff79432D),
    primary: Colors.white,
    secondary: Color(0xffECE8E6),
  ),
);

extension CoffeeColors on ColorScheme {
  Color get coffeeCardBackground => brightness == Brightness.dark
      ? const Color(0xff794028)
      : const Color(0xff4B1F0E);

  Color get coffeeCardLowerBackground => brightness == Brightness.dark
      ? const Color(0xff4B1F0E)
      : const Color(0x054B1F0E);

  Color get cartItemColor => brightness == Brightness.dark
      ? const Color(0xff4B1F0E)
      : const Color(0xffffffff);

  Color get settingsCard => brightness == Brightness.dark
      ? const Color(0xff794028)
      : const Color(0xffffffff);
}
