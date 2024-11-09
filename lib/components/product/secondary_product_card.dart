import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qurban_mart/controller/cart_controller.dart';
import 'package:qurban_mart/models/cart_model.dart';
import 'package:qurban_mart/values/dialog_utils.dart';
import 'package:qurban_mart/values/math_utils.dart';
import 'package:qurban_mart/values/output_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class SecondaryProductCard extends StatelessWidget {
  const SecondaryProductCard({
    super.key,
    required this.data,
    this.press,
    this.style,
  });

  final CombinedCart data;
  final VoidCallback? press;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final NumberFormat currencyFormat = NumberFormat.decimalPattern('id');

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

    void showPaymentDialog() {
      double heightImage = 200;
      double widthImage = 200;

      final ImagePicker picker = ImagePicker();

      Future<void> pickImage(ImageSource source) async {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          cartController.buktiPembayaran.value = image;
          // Perbarui dialog dengan setState atau logika sesuai konteks Anda
        }
      }

      void showImageSourceActionSheet() {
        showModalBottomSheet(
          context: context,
          builder: (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      }

      dialogShow(
        context: context,
        title: "Konfirmasi Pembayaran DP",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Obx(() {
                  final img = cartController.buktiPembayaran.value;
                  return GestureDetector(
                      onTap: () async {
                        showImageSourceActionSheet();
                      },
                      child: img != null
                          ? Image.file(
                              File(img.path),
                              fit: BoxFit.cover,
                              height: heightImage,
                              width: widthImage,
                            )
                          : (data.produk.buktiPembayaran != ""
                              ? Image.network(
                                  data.produk.buktiPembayaran.toString(),
                                  fit: BoxFit.cover,
                                  height: heightImage,
                                  width: widthImage,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image,
                                        color: Colors.red);
                                  },
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // Menambahkan padding di sekitar konten
                                    child: Align(
                                      alignment: Alignment
                                          .center, // Memastikan teks berada di tengah
                                      child: Text(
                                        'Klik untuk mengganti gambar',
                                        textAlign: TextAlign
                                            .center, // Memastikan teks berada di tengah secara horizontal
                                        style: TextStyle(
                                          fontSize: 14, // Ukuran font
                                          fontWeight:
                                              FontWeight.w500, // Berat font
                                        ),
                                      ),
                                    ),
                                  ),
                                )));
                }),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: IconButton(
                //     icon: Icon(
                //       Icons.edit,
                //       color: Colors.green,
                //       size: 24,
                //     ),
                //     onPressed: () async {
                //       await pickImage();
                //       setState(() {});
                //     },
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            // Nama Penjual dan Nomor Rekening dengan Border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Nama Penjual',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${data.produk.namaPenjual}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ), // Batas antara nama penjual dan rekening
                  ListTile(
                    title: Text(
                      'Nomor Rekening',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${data.produk.noRekening}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ), // Batas antara nama penjual dan rekening
                  ListTile(
                    title: Text(
                      'Total DP',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Rp. ${currencyFormat.format(calculatePercent(20, data.produk.harga!.toDouble()))}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            // cartController.resetBuktiPembayaran();
            final loading = cartController.loading.value;

            return Padding(
              padding: const EdgeInsets.all(
                  8.0), // Menambahkan padding sekitar tombol
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Menyusun tombol di kanan
                children: [
                  Container(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Ubah warna background menjadi merah
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16), // Memberi jarak antara tombol
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.updateBuktiPembayaran(
                            id: data.cart.id,
                            idProduk: data.produk.id,
                            context: context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, // Ubah warna background menjadi hijau
                      ),
                      child: loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Konfirmasi'),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    }

    Color colorStatusPembayaran(String? statusPembayaran) {
      Color color = Colors.red;

      if (data.produk.idCart == data.cart.id) {
        if (statusPembayaran == StatusPembayaran.pembayaranDiProses.deskripsi) {
          color = Color.fromARGB(255, 206, 136, 23);
        } else if (statusPembayaran ==
            StatusPembayaran.pembayaranBerhasil.deskripsi) {
          color = Colors.green;
        }
      }

      return color;
    }

    Color colorStatusPengiriman(String? statusPengiriman) {
      Color color = Colors.red;

      if (statusPengiriman == StatusPengiriman.sedangDiantar.deskripsi) {
        color = Color.fromARGB(255, 206, 136, 23);
      } else if (statusPengiriman ==
          StatusPengiriman.pesananSelesai.deskripsi) {
        color = Colors.green;
      }

      return color;
    }

    return OutlinedButton(
      onPressed: press,
      style: style ??
          OutlinedButton.styleFrom(
              minimumSize: const Size(256, 144),
              maximumSize: const Size(256, 144),
              padding: const EdgeInsets.all(8)),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                NetworkImageWithLoader(data.produk.image.toString(),
                    radius: defaultBorderRadious),
              ],
            ),
          ),
          const SizedBox(width: defaultPadding / 4),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data.produk.kategori.toString().toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10),
                      ),
                      Spacer(), // Menambahkan Spacer untuk mendorong elemen ke kanan
                      Container(
                        padding: const EdgeInsets.all(
                          defaultPadding / 3,
                        ),
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorStatusPembayaran(
                              data.produk.statusPembayaran),
                          borderRadius: BorderRadius.all(
                              Radius.circular(defaultBorderRadious)),
                        ),
                        child: Text(
                          data.produk.idCart == data.cart.id
                              ? data.produk.statusPembayaran.toString()
                              : data.produk.isPemesan == true
                                  ? "Ada pemesan"
                                  : data.produk.statusPembayaran.toString() ==
                                          StatusPembayaran
                                              .pembayaranBerhasil.deskripsi
                                      ? "Produk telah habis"
                                      : data.cart.statusPembayaran != ""
                                          ? data.cart.statusPembayaran
                                              .toString()
                                          : StatusPembayaran
                                              .belumDibayar.deskripsi,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 3),
                  Text(
                    data.produk.nama.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      Text(
                        "Rp. ${currencyFormat.format(data.produk.harga)}",
                        style: const TextStyle(
                          color: Color(0xFF31B0D8),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      // Spacer(), // Menambahkan Spacer untuk mendorong elemen ke kanan
                      // Text(
                      //   "DP: Rp. ${currencyFormat.format(calculatePercent(20, data.harga!.toDouble()))}",
                      //   style: const TextStyle(
                      //     color: Color.fromARGB(255, 216, 77, 49),
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      data.produk.isPemesan == false &&
                              data.produk.statusPembayaran !=
                                  StatusPembayaran.pembayaranBerhasil.deskripsi
                          ? ElevatedButton(
                              onPressed: showPaymentDialog,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 24), // and this
                              ),
                              child: const Text("Bayar DP",
                                  style: TextStyle(fontSize: 10)),
                            )
                          : data.produk.statusPembayaran ==
                                      StatusPembayaran
                                          .pembayaranBerhasil.deskripsi &&
                                  data.produk.idCart == data.cart.id
                              ? Container(
                                  padding: const EdgeInsets.all(
                                    defaultPadding / 3,
                                  ),
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: colorStatusPengiriman(
                                        data.produk.statusPengiriman),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(defaultBorderRadious)),
                                  ),
                                  child: Text(
                                    data.produk.statusPengiriman.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                            child: IconButton(
                              icon: const Icon(Icons.chat,
                                  size: 20, color: Colors.green),
                              onPressed: () {
                                openWhatsAppOrCall(data.produk.noHp.toString(),
                                    'Halo, saya tertarik dengan produk ini.');
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: IconButton(
                              icon: const Icon(Icons.location_on,
                                  size: 20, color: Colors.red),
                              onPressed: () {
                                if (data.produk.lokasi != null) {
                                  openMaps(data.produk.lokasi!.latitude,
                                      data.produk.lokasi!.longitude);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
