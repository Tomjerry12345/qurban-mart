import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_mart/components/cart_button.dart';
import 'package:qurban_mart/constants.dart';
import 'package:qurban_mart/controller/auth_controller.dart';
import 'package:qurban_mart/controller/produk_controller.dart';
import 'package:qurban_mart/models/product_model.dart';
import 'package:qurban_mart/route/route_constants.dart';
import 'package:qurban_mart/values/output_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final produkController = Get.find<ProdukController>();
    final authController = Get.find<AuthController>();

    Future<void> openWhatsAppOrCall(String phoneNumber, String message) async {
      final whatsappUrl = Uri.parse(
          'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      final phoneUrl = Uri.parse('tel:$phoneNumber');

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl, mode: LaunchMode.externalApplication);
      } else {
        logO('Could not launch WhatsApp or Phone');
      }
    }

    Future<void> openMaps(double latitude, double longitude) async {
      final url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      bottomNavigationBar: CartButton(
        title: "Simpan",
        price: product.harga!.toDouble(),
        press: () {
          if (authController.currentUser.value == "") {
            showSnackbar("Terjadi kesalahan!",
                "Login terlebih dahulu untuk memesan!", StatusSnackbar.error);
            authController.onLogout();
            Navigator.pushNamedAndRemoveUntil(context, logInScreenRoute,
                ModalRoute.withName(entryPointScreenRoute));
            return;
          }
          produkController.addToCart(product, authController.currentUser.value);
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: SvgPicture.asset("assets/icons/Bookmark.svg",
              //         color: Theme.of(context).textTheme.bodyLarge!.color),
              //   ),
              // ],
            ),
            ProductImages(
              images: [product.image.toString()],
            ),
            ProductInfo(
              brand: product.kategori.toString(),
              title: product.nama.toString(),
              // isAvailable: true,
              // description:
              //     "A cool gray cap in soft corduroy. Watch me.' By buying cotton products from Lindex, you’re supporting more responsibly...",
              // rating: 4.4,
              // numOfReviews: 126,
            ),
            ProductListTile(
              title: "Umur",
              value: "${product.usia} Bulan",
            ),
            ProductListTile(
              title: "Berat",
              value: "${product.berat} kg",
            ),
            ProductListTile(
              title: "Lokasi",
              value: "",
              isShowBottomBorder: true,
              press: () {
                // customModalBottomSheet(
                //   context,
                //   height: MediaQuery.of(context).size.height * 0.92,
                //   child: MapsScreen(
                //     location: product.lokasi,
                //   ),
                // );
                openMaps(product.lokasi!.latitude, product.lokasi!.longitude);
              },
            ),
            ProductListTile(
              title: "No hp",
              value: product.noHp.toString(),
              isShowBottomBorder: true,
              press: () {
                openWhatsAppOrCall(product.noHp.toString(),
                    'Halo, saya tertarik dengan produk ini.');
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
