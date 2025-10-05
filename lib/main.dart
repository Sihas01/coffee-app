import 'package:coffee_app/models/cart_model.dart';
import 'package:coffee_app/screens/route_screen.dart';
import 'package:coffee_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Themeprovider()),
      ChangeNotifierProvider(create: (context) => CartModel()),
    ],

    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffe App',
      theme: Provider.of<Themeprovider>(context).themeData,
      home: RouteScreen(),
    );
  }
}
