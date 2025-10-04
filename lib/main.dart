import 'package:coffee_app/screens/HomeScreen.dart';
import 'package:coffee_app/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => Themeprovider(),
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
      home: HomeScreen(),
    );
  }
}
