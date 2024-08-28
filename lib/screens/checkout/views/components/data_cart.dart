import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_mart/components/product/secondary_product_card.dart';
import 'package:qurban_mart/controller/auth_controller.dart';
import 'package:qurban_mart/controller/cart_controller.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class DataCart extends StatelessWidget {
  const DataCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final authController = Get.find<AuthController>();

    return Obx(() {
      final username = authController.currentUser.value;
      cartController.getDataCart(username);

      final dataCart = cartController.cartData.value;

      return Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: dataCart.isEmpty
            ? MainAxisAlignment.center
            : MainAxisAlignment.start, // Center vertically
        children: [
          const SizedBox(height: defaultPadding / 2),
          if (dataCart.isEmpty)
            const Center(
              child: Text("Data cart tidak ada"),
            )
          else
            SizedBox(
              height: 560,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  // Find demoPopularProducts on models/ProductModel.dart
                  itemCount: dataCart.length,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(defaultPadding - 10
                            // left: defaultPadding,
                            // right: index == demoPopularProducts.length - 1
                            //     ? defaultPadding
                            //     : 0,
                            ),
                        child: SecondaryProductCard(
                          data: dataCart[index],
                          press: () {
                            Navigator.pushNamed(
                                context, productDetailsScreenRoute,
                                arguments: index.isEven);
                          },
                        ),
                      )),
            ),
        ],
      );
    });
  }
}
