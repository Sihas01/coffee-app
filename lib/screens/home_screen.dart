import 'package:coffee_app/models/cart_model.dart';
import 'package:coffee_app/widget/custom_chip.dart';
import 'package:coffee_app/widget/custom_top_bar.dart';
import 'package:coffee_app/widget/product_card.dart';
import 'package:coffee_app/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<CartModel>(context).products;
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
    );
  }
}
