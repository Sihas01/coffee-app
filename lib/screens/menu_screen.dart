import 'package:coffee_app/models/cart_model.dart';
import 'package:coffee_app/widget/product_grid.dart';
import 'package:coffee_app/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<CartModel>(context);
    final featued = products.products;
    final newarrival = products.newArrivals;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 27,
            right: 25,
            left: 25,
            bottom: 20,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Text(
                      "Products",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(children: [TitleText(title: "Featured Products")]),
              ),
              ProductGrid(setction: featued, isMenu: true),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(children: [TitleText(title: "New Arrivals")]),
              ),
              ProductGrid(setction: newarrival, isMenu: true),
            ],
          ),
        ),
      ),
    );
  }
}
