import 'package:admin_qurban_mart/components/button/button_component.dart';
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
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.only(
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
                DataColumn(
                  label: Text("Gambar"),
                ),
                DataColumn(
                  label: Text("Nama"),
                ),
                DataColumn(
                  label: Text("kategori"),
                ),
                DataColumn(
                  label: Text("Harga"),
                ),
                DataColumn(label: Text("Status")),
                DataColumn(
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

  Future<void> updateStatus() async {
    final dataMap = data.toMap();

    try {
      logO("id", m: data.id.toString());
      await fs.updateDataSpecifictDoc("produk", data.id.toString(),
          {...dataMap, "status": "Telah terjual"});
    } catch (e) {
      logO("errro", m: e);
    }
  }

  return DataRow(
    cells: [
      DataCell(Image.network(
        data.image!,
        height: 30,
        width: 30,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error, color: Colors.red);
        },
      )),
      DataCell(Text(data.nama!)),
      DataCell(Text(data.kategori!)),
      DataCell(Text(data.harga.toString())),
      DataCell(ButtonComponent(
        data.status.toString(),
        color: Colors.red,
        onPressed: updateStatus,
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
