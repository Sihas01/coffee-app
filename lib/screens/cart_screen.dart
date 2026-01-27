import 'package:coffee_app/models/cart_model.dart';
import 'package:coffee_app/theme/theme.dart';
import 'package:coffee_app/widget/custom_chip.dart';
import 'package:coffee_app/widget/location_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    String getCupSizeShortLabel(String size) {
      switch (size.toLowerCase()) {
        case 'small':
          return 'S';
        case 'medium':
          return 'M';
        case 'large':
          return 'L';
        default:
          return size; // fallback to original label if it's unexpected
      }
    }

    double totalPrice = cart.getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: cart.cartItems.isEmpty
          ? Center(
              child: Text(
                "Cart is empty",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 27,
                            right: 25,
                            left: 25,
                            bottom: 20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cart",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  Text(
                                    "Selected Items : ${cart.cartItems.length}",
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              LocationTile(),
                              SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cart.cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cart.cartItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.cartItemColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .coffeeCardBackground,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Image.asset(
                                                item.product.imagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          item
                                                              .product
                                                              .productName,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.primary,
                                                              ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          cart.removeFromCart(
                                                            item,
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        CustomChip(
                                                          label:
                                                              getCupSizeShortLabel(
                                                                item.cupSize,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 5,
                                                              ),
                                                          child: CustomChip(
                                                            label:
                                                                '${item.sugarCount}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 16,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Rs. ${item.product.price.toStringAsFixed(2)}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.primary,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 27,
                    right: 25,
                    left: 25,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Total Price is : ${totalPrice.toStringAsFixed(2)}'),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.background,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text('Checkout'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
