import 'dart:async';
import 'package:coffee_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:screen_brightness/screen_brightness.dart';

class Themeprovider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  StreamSubscription? _subscription;
  final Light _light = Light();

  Themeprovider() {
    _initLightSensor();
  }

  ThemeMode get themeMode => _themeMode;

  void _initLightSensor() {
    // Only try to initialize on Android/iOS (the 'light' plugin usually only supports these)
    // We also use a try-catch to handle the MissingPluginException if the app hasn't been rebuilt
    try {
      _subscription = _light.lightSensorStream.listen((int lux) {
        print("Ambient Light Level: $lux Lux"); // DEBUG LOG
        
        // Automatic Brightness Management
        _updateScreenBrightness(lux);

      }, onError: (error) {
        print("Light sensor stream error: $error");
      });
    } on Exception catch (e) {
      print("Light sensor initialization failed: $e");
    } catch (e) {
      if (e.toString().contains('MissingPluginException')) {
        print("CRITICAL: Ambient Light Sensor requires a FULL APP REBUILD (Stop and Start). Hot reload is not enough.");
      } else {
        print("Light sensor error: $e");
      }
    }
  }

  Future<void> _updateScreenBrightness(int lux) async {
    try {
      // Logic for brightness: 
      // Very dark (< 10 lux) -> 10-20% brightness
      // Indoor/Normal (10 - 500 lux) -> 30-70% brightness
      // Outdoor/Bright (> 500 lux)  -> 80-100% brightness
      
      double targetBrightness;
      if (lux < 10) {
        targetBrightness = 0.2;
      } else if (lux < 100) {
        targetBrightness = 0.4;
      } else if (lux < 500) {
        targetBrightness = 0.7;
      } else {
        targetBrightness = 1.0;
      }

      await ScreenBrightness().setScreenBrightness(targetBrightness);
    } catch (e) {
      print("Could not set screen brightness: $e");
    }
  }

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

  @override
  void dispose() {
    _subscription?.cancel();
    // Reset brightness to system default when provider is destroyed if needed
    ScreenBrightness().resetScreenBrightness();
    super.dispose();
  }

  ThemeData get lightTheme => lightMode;
  ThemeData get darkTheme => darkMode;
}
