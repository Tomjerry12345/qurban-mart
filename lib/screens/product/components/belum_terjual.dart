import 'package:admin_qurban_mart/components/button/button_component.dart';
import 'package:admin_qurban_mart/components/button/dropdown_button.dart';
import 'package:admin_qurban_mart/components/button/icon_button_component.dart';
import 'package:admin_qurban_mart/controllers/page_controller.dart';
import 'package:admin_qurban_mart/controllers/product_controller.dart';
import 'package:admin_qurban_mart/models/Products.dart';
import 'package:admin_qurban_mart/router/router_constant.dart';
import 'package:admin_qurban_mart/services/firebase_services.dart';
import 'package:admin_qurban_mart/values/confirm_dialog.dart';
import 'package:admin_qurban_mart/values/output_utils.dart';
import 'package:admin_qurban_mart/values/position_utils.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class BelumTerjual extends StatelessWidget {
  final List<Product> data;
  const BelumTerjual(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                const DataColumn(
                  label: Text("Gambar"),
                ),
                const DataColumn(
                  label: Text("Nama"),
                ),
                // DataColumn(
                //   label: Text("kategori"),
                // ),
                // DataColumn(
                //   label: Text("Harga"),
                // ),
                const DataColumn(label: Text("Status pembayaran")),
                const DataColumn(label: Text("Status pengiriman")),
                const DataColumn(
                  label: Text("Action"),
                ),
              ],
              rows: List.generate(
                data.length,
                (index) => recentFileDataRow(data[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan modal dialog
void showStatusPembayaranDialog(
    BuildContext context,
    Product data,
    Function({required String key, dynamic value, bool isDeleteIdCart})
        onUpdateStatus) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Status Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Apakah Anda ingin mengubah status pembayaran menjadi "${StatusPembayaran.pembayaranBerhasil.deskripsi}"?'),
            const SizedBox(height: 16),
            data.buktiPembayaran != null && data.buktiPembayaran!.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      // Tampilkan modal perbesaran gambar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    data.buktiPembayaran!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image,
                                          color: Colors.red);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Tutup dialog perbesar gambar
                                    },
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Image.network(
                      data.buktiPembayaran!,
                      fit: BoxFit.cover,
                      height: 400, // Sesuaikan tinggi gambar
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            color: Colors.red);
                      },
                    ),
                  )
                : const Text('Tidak ada bukti pembayaran tersedia'),
          ],
        ),
        actions: [
          ButtonComponent(
            "Batalkan pembayaran",
            onPressed: () async {
              Navigator.of(context).pop(); // Tutup dialog
              if (data.buktiPembayaran != null &&
                  data.buktiPembayaran!.isNotEmpty) {
                await onUpdateStatus(
                    key: "statusPembayaran",
                    value: StatusPembayaran.pembayaranGagal.deskripsi,
                    isDeleteIdCart: true); // Panggil fungsi untuk update status
              }
            },
            color: Colors.red,
          ),
          ButtonComponent(
            "Konfirmasi",
            onPressed: () async {
              Navigator.of(context).pop(); // Tutup dialog
              if (data.buktiPembayaran != null &&
                  data.buktiPembayaran!.isNotEmpty) {
                await onUpdateStatus(
                    key: "statusPembayaran",
                    value: StatusPembayaran.pembayaranBerhasil
                        .deskripsi); // Panggil fungsi untuk update status
              }
            },
          ),
        ],
      );
    },
  );
}

DataRow recentFileDataRow(Product data, BuildContext context) {
  final fs = FirebaseServices();
  final GetxPageController c = Get.find();
  final ProductController p = Get.put(ProductController());

  void onClickHapus() {
    showConfirmDialog(
        context: context,
        title: "Hapus",
        message: "Apakah anda yakin ingin menghapus data ini?",
        onConfirm: () async {
          await fs.deleteDoc("produk", data.id.toString());
        });
  }

  void onView() {
    p.setProduct(data);
    c.changePage(viewProductScreenRoute);
  }

  Future<void> updateStatus({required String key, value}) async {
    final dataMap = data.toMap();

    try {
      logO("id", m: data.id.toString());
      await fs.updateDataSpecifictDoc(
          "produk", data.id.toString(), {...dataMap, key: value});
    } catch (e) {
      logO("errro", m: e);
    }
  }

  Future<void> updateStatusPembayaran(
      {required String key, value, bool isDeleteIdCart = false}) async {
    final dataMap = data.toMap();

    try {
      logO("id", m: data.id.toString());
      await fs
          .updateDataSpecifictDoc("cart", data.idCart.toString(), {key: value});
      await fs.updateDataSpecifictDoc("produk", data.id.toString(), {
        ...dataMap,
        key: value,
        "idCart": isDeleteIdCart ? "" : data.idCart,
        "isPemesan": false,
        "buktiPembayaran": ""
      });
    } catch (e) {
      logO("errro", m: e);
    }
  }

  Color colorStatusPembayaran() {
    Color color = Colors.red;

    if (data.statusPembayaran ==
        StatusPembayaran.pembayaranDiProses.deskripsi) {
      color = const Color.fromARGB(255, 206, 136, 23);
    } else if (data.statusPembayaran ==
        StatusPembayaran.pembayaranBerhasil.deskripsi) {
      color = Colors.green;
    }

    return color;
  }

  return DataRow(
    cells: [
      DataCell(Image.network(
        data.image!,
        height: 30,
        width: 30,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, color: Colors.red);
        },
      )),
      DataCell(Text(data.nama!)),
      // DataCell(Text(data.kategori!)),
      // DataCell(Text(data.harga.toString())),
      DataCell(ButtonComponent(
        data.statusPembayaran.toString(),
        color: colorStatusPembayaran(),
        onPressed: () {
          showStatusPembayaranDialog(context, data, updateStatusPembayaran);
        },
        icon: Icons.visibility_outlined,
        size: 10,
      )),
      DataCell(DropdownButtonComponent(
        items: [
          StatusPengiriman.belumDikirim.deskripsi,
          StatusPengiriman.sedangDiantar.deskripsi,
          StatusPengiriman.pesananSelesai.deskripsi
        ],
        defaultValue: data.statusPengiriman,
        color: data.statusPengiriman == StatusPengiriman.belumDikirim.deskripsi
            ? Colors.red[500]
            : Colors.yellow[800],
        onChanged: (value) {
          updateStatus(key: "statusPengiriman", value: value);
        },
      )),
      DataCell(
        Row(
          children: [
            IconButtonComponent(
              Icons.visibility_outlined,
              color: Colors.blue,
              onPressed: onView,
            ),
            H(8),
            IconButtonComponent(
              Icons.delete,
              color: Colors.red,
              onPressed: onClickHapus,
            ),
          ],
        ),
      ),
    ],
  );
}
