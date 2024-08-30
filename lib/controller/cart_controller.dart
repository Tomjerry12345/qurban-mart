import 'package:get/get.dart';
import 'package:qurban_mart/constants.dart';
import 'package:qurban_mart/models/cart_model.dart';
import 'package:qurban_mart/services/firebase_services.dart';
import 'package:qurban_mart/values/output_utils.dart';

class CartController extends GetxController {
  var cartData = Rx<List<Cart>>([]);

  final _fs = FirebaseServices();

  void reset() {
    cartData.value = [];
  }

  void getDataCart(String username) async {
    final snapCart =
        await _fs.getDataCollectionByQuery("cart", "pembeli", username);

    List<Cart> cart = [];

    if (snapCart.isNotEmpty) {
      for (var e in snapCart) {
        final dataCart = e.data();
        final snapProduk = await _fs.getDataDoc("produk", dataCart["idProduk"]);
        final dataProduk = snapProduk.data();
        if (dataProduk != null) {
          if (dataProduk["status"] == belumTerjual) {
            cart.add(Cart.fromMap(dataCart));
          }
        }
      }
    }

    cartData.value = cart;
  }
}
