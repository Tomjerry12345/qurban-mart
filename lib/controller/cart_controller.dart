import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qurban_mart/constants.dart';
import 'package:qurban_mart/controller/auth_controller.dart';
import 'package:qurban_mart/models/cart_model.dart';
import 'package:qurban_mart/models/product_model.dart';
import 'package:qurban_mart/services/firebase_services.dart';
import 'package:qurban_mart/values/output_utils.dart';

class CombinedCart {
  final Cart cart;
  final Product produk;

  CombinedCart({required this.cart, required this.produk});

  factory CombinedCart.fromMaps(
      Map<String, dynamic> dataCart, Map<String, dynamic> dataProduk) {
    return CombinedCart(
      cart: Cart.fromMap(dataCart),
      produk: Product.fromMap(dataProduk),
    );
  }
}

class CartController extends GetxController {
  var cartData = Rx<List<CombinedCart>>([]);

  final _fs = FirebaseServices();
  final authController = Get.put(AuthController());

  var loading = false.obs;
  Rxn<XFile> buktiPembayaran = Rxn<XFile>();

  void reset() {
    cartData.value = [];
  }

  void resetBuktiPembayaran() {
    loading.value = false;
    buktiPembayaran.value = null;
  }

  void getDataCart(String username) async {
    final snapCart =
        await _fs.getDataCollectionByQuery("cart", "pembeli", username);

    List<CombinedCart> combinedCarts = [];

    if (snapCart.isNotEmpty) {
      for (var e in snapCart) {
        final dataCart = e.data();
        final snapProduk = await _fs.getDataDoc("produk", dataCart["idProduk"]);
        final dataProduk = snapProduk.data();
        if (dataProduk != null) {
          if (dataProduk["statusPengiriman"] !=
              StatusPengiriman.pesananSelesai) {
            combinedCarts.add(CombinedCart.fromMaps(dataCart, dataProduk));
          }
        }
      }
    }

    cartData.value = combinedCarts;
  }

  Future<void> updateBuktiPembayaran(
      {required String? id,
      required BuildContext context,
      String? idProduk}) async {
    // final ImagePicker _picker = ImagePicker();
    // final XFile? image = await _picker.pickImage(source: source);

    final valBuktiPembayaran = buktiPembayaran.value;

    if (valBuktiPembayaran != null) {
      loading.value = true;

      File file = File(valBuktiPembayaran.path);
      String fileName =
          "${authController.currentUser.value}_${DateTime.now().millisecondsSinceEpoch}.png";

      logO("fileName", m: fileName);

      final urlImage = await _fs.uploadFile(file, fileName, "cart");
      await _fs.updateDataSpecifictDoc("produk", idProduk!, {
        "idCart": id,
        "buktiPembayaran": urlImage,
        "statusPembayaran": StatusPembayaran.pembayaranDiProses.deskripsi,
        "isPemesan": true
      });

      loading.value = false;

      resetBuktiPembayaran();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }
}
