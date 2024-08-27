import 'package:flutter/material.dart';
import 'package:qurban_mart/components/product/secondary_product_card.dart';
import 'package:qurban_mart/models/cart_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class DataCart extends StatelessWidget {
  final List<Cart> data;

  const DataCart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        SizedBox(
          height: 560,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            // Find demoPopularProducts on models/ProductModel.dart
            itemCount: data.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(defaultPadding - 10
                  // left: defaultPadding,
                  // right: index == demoPopularProducts.length - 1
                  //     ? defaultPadding
                  //     : 0,
                  ),
              child: SecondaryProductCard(
                data: data[index],
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: index.isEven);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
