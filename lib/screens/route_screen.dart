import 'package:coffee_app/screens/cart_screen.dart';
import 'package:coffee_app/screens/home_screen.dart';
import 'package:coffee_app/screens/menu_screen.dart';
import 'package:coffee_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  int currentIndex = 0;
  List<Widget> pages = [HomeScreen(), MenuScreen(), Cart(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // Each screen manages its own AppBar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.background,
        currentIndex: currentIndex,
        selectedItemColor: Color.fromARGB(255, 255, 242, 232),
        unselectedItemColor: Color(0xffEFC3A4),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Menu'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
