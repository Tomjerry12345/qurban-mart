import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_mart/components/product/product_card.dart';
import 'package:qurban_mart/controller/produk_controller.dart';
import 'package:qurban_mart/models/product_model.dart';
import 'package:qurban_mart/route/route_constants.dart';
import 'package:qurban_mart/screens/home/views/components/search_form.dart';
import 'package:flutter/material.dart';
import 'package:qurban_mart/constants.dart';
import 'package:qurban_mart/services/firebase_services.dart';

import 'components/offer_carousel_and_categories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirebaseServices();
    final produkController = Get.find<ProdukController>();

    return Scaffold(
      body: Obx(() {
        final kategori = produkController.kategori.value;
        final cari = produkController.cari.value;
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: kategori != "All Categories"
                ? fs.getDataQueryStream("produk", "kategori", kategori)
                : cari != ""
                    ? fs.onSearching("produk", "nama", cari)
                    : fs.getDataStreamCollection("produk"),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs;

              List<Product> data = [];

              if (docs != null) {
                data = docs
                    .map((doc) {
                      return Product.fromMap(doc.data());
                    })
                    .where((product) => product.status == belumTerjual)
                    .toList();
              }

              return SafeArea(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                        child: OffersCarouselAndCategories()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: defaultPadding),
                      sliver: const SliverToBoxAdapter(
                        child: SearchForm(),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: defaultPadding),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio: 0.66,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return ProductCard(
                              image: data[index].image.toString(),
                              category: data[index].kategori.toString(),
                              title: data[index].nama.toString(),
                              price: data[index].harga,
                              weight: data[index].berat,
                              age: data[index].usia,
                              press: () {
                                produkController.reset();
                                Navigator.pushNamed(
                                    context, productDetailsScreenRoute,
                                    arguments: data[index]);
                              },
                            );
                          },
                          childCount: data.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
