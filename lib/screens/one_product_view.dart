import 'package:coffee_app/models/cart_model.dart';
import 'package:coffee_app/models/product_model.dart';
import 'package:coffee_app/screens/cart_screen.dart';
import 'package:coffee_app/widget/custom_chip.dart';
import 'package:coffee_app/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/models/cart_item.dart';
import 'package:provider/provider.dart';

class OneProductView extends StatefulWidget {
  final Product product;
  const OneProductView({super.key, required this.product});

  @override
  State<OneProductView> createState() => _OneProductViewState();
}

class _OneProductViewState extends State<OneProductView> {
  String? selectedCupSize;
  String? sugarCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              print("test");
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite_outline_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 360,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(21),
                  bottomRight: Radius.circular(21),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(70.0),
                child: Image.asset(
                  widget.product.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 27, right: 25, left: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.productName,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        'Rs. ${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          "${widget.product.ratingAvg.toStringAsFixed(2)} (${widget.product.rating})",
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(children: [TitleText(title: "Cup Size")]),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CustomChip(
                                  label: "Small",
                                  selected: selectedCupSize == "Small",
                                  onTap: () {
                                    setState(() {
                                      selectedCupSize = "Small";
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CustomChip(
                                  label: "Medium",
                                  selected: selectedCupSize == "Medium",
                                  onTap: () {
                                    setState(() {
                                      selectedCupSize = "Medium";
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CustomChip(
                                  label: "Large",
                                  selected: selectedCupSize == "Large",
                                  onTap: () {
                                    setState(() {
                                      selectedCupSize = "Large";
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(children: [TitleText(title: "Sugar")]),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              CustomChip(
                                label: "1",
                                selected: sugarCount == "1",
                                onTap: () {
                                  setState(() {
                                    sugarCount = "1";
                                  });
                                },
                              ),
                              SizedBox(width: 12),
                              CustomChip(
                                label: "2",
                                selected: sugarCount == "2",
                                onTap: () {
                                  setState(() {
                                    sugarCount = "2";
                                  });
                                },
                              ),
                              SizedBox(width: 12),
                              CustomChip(
                                label: "3",
                                selected: sugarCount == "3",
                                onTap: () {
                                  setState(() {
                                    sugarCount = "3";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(children: [TitleText(title: "Description")]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "A cappuccino is an espresso-based coffee drink traditionally composed of equal parts espresso, steamed milk, and milk foam, creating a balanced and layered beverage.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 8,
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedCupSize == null || sugarCount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please select cup size and sugar amount",
                          ),
                        ),
                      );
                      return;
                    }
                    final cartItem = CartItem(
                      product: widget.product,
                      cupSize: selectedCupSize!,
                      sugarCount: int.parse(sugarCount!),
                    );

                    Provider.of<CartModel>(
                      context,
                      listen: false,
                    ).addToCart(cartItem);

                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (context) => Cart()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('Add to cart'),
                ),
              ),
            ),
          ],
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
