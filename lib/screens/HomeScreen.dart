import 'package:coffee_app/models/productModel.dart';
import 'package:coffee_app/widget/CustomChip.dart';
import 'package:coffee_app/widget/CustomTopBar.dart';
import 'package:coffee_app/widget/ProductCard.dart';
import 'package:coffee_app/widget/titleText.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      productName: 'Espresso',
      imagePath: 'asset/images/cappuccino.png',
      price: 690.99,
    ),
    Product(
      productName: 'Cappuccino',
      imagePath: 'asset/images/cappuccinoTwo.png',
      price: 1080.00,
    ),
    Product(
      productName: 'Ice Latte',
      imagePath: 'asset/images/cappuccino.png',
      price: 1080.00,
    ),
    Product(
      productName: 'Mocha',
      imagePath: 'asset/images/cappuccino.png',
      price: 700.99,
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 27, right: 25, left: 25),
          child: Column(
            children: [
              Row(children: [TitleText(title: "Deals & Promotions")]),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row(children: [TitleText(title: "Categories")]),

                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CustomChip(label: "Ice Latte"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CustomChip(label: "Espresso"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CustomChip(label: "Cappuccino"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CustomChip(label: "Mocha"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(children: [TitleText(title: "Featured Products")]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 290,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.background,
        currentIndex: 0,
        selectedItemColor: Color.fromARGB(255, 255, 242, 232),
        unselectedItemColor: Color(0xffEFC3A4),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        // onTap: (index) {
        //   setState(() {
        //     _selectedIndex = index;
        //   });
        // },
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
