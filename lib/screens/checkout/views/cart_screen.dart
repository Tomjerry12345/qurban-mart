import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qurban_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:qurban_mart/models/cart_model.dart';
import 'package:qurban_mart/screens/checkout/views/components/data_cart.dart';
import 'package:qurban_mart/services/firebase_services.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirebaseServices();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: fs.getDataStreamCollection("cart"),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs;

            List<Cart> data = [];

            if (docs != null) {
              data = docs.map((doc) {
                return Cart.fromMap(doc.data());
              }).toList();
            }
            return SafeArea(
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
                  SliverToBoxAdapter(
                      child: DataCart(
                    data: data,
                  ))
                ],
              ),
            );
          }),
    );
  }
}
