import 'package:coffee_app/theme/themeProvider.dart';
import 'package:coffee_app/widget/CustomTopBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom AppBar',
      theme: Provider.of<Themeprovider>(context).themeData,
      home: Scaffold(appBar: CustomTopBar()),
    );
  }
}
