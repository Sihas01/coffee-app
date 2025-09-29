import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom AppBar',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 225,
          backgroundColor: const Color(0xff794028),
          flexibleSpace: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset('asset/images/coffee.png'),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 40, right: 25,left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, John",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        Text(
                          "Good Morning",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.settings),
                        Icon(Icons.notifications_none),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
