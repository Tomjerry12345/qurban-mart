import 'package:flutter/material.dart';

Color? primaryColor = Colors.blue[800];
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const tabActivateColor = Color.fromARGB(255, 35, 38, 52);
const tabNotactivateColor = Color.fromARGB(255, 68, 74, 101);

const defaultPadding = 16.0;

const KEY_ISLOGGING = "is-logging";

enum StatusPenjualan {
  belumTerjual("Belum terjual"),
  terjual("Terjual");

  final String deskripsi;

  const StatusPenjualan(this.deskripsi);
}

enum StatusPengiriman {
  belumDikirim("Belum dikirim"),
  sedangDiantar("Sedang diantar"),
  pesananSelesai("Pesanan selesai");

  final String deskripsi;

  const StatusPengiriman(this.deskripsi);
}

enum StatusPembayaran {
  belumDibayar("Belum dibayar"),
  pembayaranDiProses("Pembayaran di proses"),
  pembayaranBerhasil("Pembayaran berhasil"),
  pembayaranGagal("Pembayaran gagal");

  final String deskripsi;

  const StatusPembayaran(this.deskripsi);
}
