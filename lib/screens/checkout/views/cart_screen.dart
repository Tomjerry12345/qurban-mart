import 'package:qurban_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:qurban_mart/screens/checkout/views/components/data_cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "Produk tersimpan",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                // const TabTransaction(),
              ],
            ),
          ),
          SliverFillRemaining(hasScrollBody: false, child: DataCart())
        ],
      ),
    ));
  }
}
