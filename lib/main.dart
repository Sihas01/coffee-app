import 'package:coffee_app/models/cart_model.dart';
import 'package:coffee_app/models/user_provider.dart';
import 'package:coffee_app/screens/login_screen.dart';
import 'package:coffee_app/screens/route_screen.dart';
import 'package:coffee_app/services/auth_service.dart';
import 'package:coffee_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Themeprovider()),
          ChangeNotifierProvider(create: (context) => CartModel()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee App',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: _isLoggedIn ? const RouteScreen() : const LoginScreen(),
    );
  }
}
