import 'package:get/get.dart';
import 'package:qurban_mart/models/product_model.dart';
import 'package:qurban_mart/services/firebase_services.dart';
import 'package:qurban_mart/values/output_utils.dart';

class ProdukController extends GetxController {
  var kategori = 'All Categories'.obs;
  var indexKategori = 0.obs;
  var cari = "".obs;

  final _fs = FirebaseServices();

  void reset() {
    kategori.value = 'All Categories';
    indexKategori.value = 0;
    cari.value = '';
  }

  Future<void> addToCart(Product product, String user) async {
    final checkDuplikat =
        await _fs.getDataCollectionByQuery("cart", "idProduk", product.id);

    if (checkDuplikat.isNotEmpty) {
      showSnackbar("Pesan!", "Produk telah di simpan!", StatusSnackbar.error);
      return;
    }

    await _fs.addDataCollection(
        "cart", {...product.toMap(), "idProduk": product.id, "pembeli": user});

    showSnackbar("Pesan!", "Berhasil tambah produk!", StatusSnackbar.success);
  }
}
