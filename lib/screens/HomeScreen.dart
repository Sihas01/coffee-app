import 'package:coffee_app/widget/CustomTopBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom AppBar',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(appBar: CustomTopBar()),
    );
  }
}
