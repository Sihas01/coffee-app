import 'package:coffee_app/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.featued,
  });

  final dynamic featued;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (constraints.maxWidth >= 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth >= 600) {
            crossAxisCount = 3;
          } else if (MediaQuery.of(context).orientation ==
              Orientation.landscape) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 2;
          }
    
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 290,
            ),
            itemCount: featued.length >= crossAxisCount
                ? crossAxisCount
                : featued.length,
            itemBuilder: (context, index) {
              return ProductCard(product: featued[index]);
            },
          );
        },
      ),
    );
  }
}
