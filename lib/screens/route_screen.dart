import 'dart:async';
import 'package:coffee_app/screens/cart_screen.dart';
import 'package:coffee_app/screens/home_screen.dart';
import 'package:coffee_app/screens/menu_screen.dart';
import 'package:coffee_app/screens/settings_screen.dart';
import 'package:coffee_app/services/connectionService.dart';

import 'package:flutter/material.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late final ConnectionService _connectionService;
  late final StreamSubscription<bool> _connectionSub;

  bool isOnline = true;

  int currentIndex = 0;
  List<Widget> pages = [HomeScreen(), MenuScreen(), Cart(), Settings()];

  @override
  void initState() {
    super.initState();

    _connectionService = ConnectionService();

    // Listen to connection changes
    _connectionSub = _connectionService.connectionStream.listen((status) {
      if (!mounted) return;
      setState(() {
        isOnline = status;
      });
    });
  }

  @override
  void dispose() {
    _connectionSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isOnline
                ? const SizedBox(width: double.infinity, height: 0)
                : SafeArea(
                    bottom: false,
                    child: Container(
                      width: double.infinity,
                      color: Colors.red.shade800,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "No Connection — Showing saved data",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: !isOnline,
              child: pages[currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(


        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.background,
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 242, 232),
        unselectedItemColor: const Color(0xffEFC3A4),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.coffee), label: 'Menu'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
