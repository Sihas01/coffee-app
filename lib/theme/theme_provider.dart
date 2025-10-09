import 'package:coffee_app/theme/theme.dart';
import 'package:flutter/material.dart';

class Themeprovider with ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  ThemeData get lightTheme => lightMode;
  ThemeData get darkTheme => darkMode;
}