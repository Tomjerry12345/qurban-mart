import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id,
      idCart,
      image,
      nama,
      kategori,
      lokasi,
      noHp,
      status,
      statusPengiriman,
      statusPembayaran,
      namaPenjual,
      noRekening,
      buktiPembayaran;
  final int? harga, usia, berat;
  final GeoPoint? location;
  final bool? isPemesan;

  Product(
      {this.id,
      this.idCart,
      this.image,
      this.nama,
      this.usia,
      this.berat,
      this.harga,
      this.kategori,
      this.lokasi,
      this.noHp,
      this.status,
      this.statusPengiriman,
      this.statusPembayaran,
      this.location,
      this.namaPenjual,
      this.noRekening,
      this.buktiPembayaran,
      this.isPemesan});

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      idCart: data['idCart'] ?? '',
      nama: data['nama'] ?? '',
      harga: data['harga'] ?? 0,
      kategori: data['kategori'] ?? '',
      usia: data['usia'] ?? 0,
      berat: data['berat'] ?? 0,
      lokasi: data['lokasi'] ?? '',
      noHp: data['noHp'] ?? '',
      image: data['image'] ?? '',
      status: data['status'] ?? '',
      statusPengiriman: data['statusPengiriman'] ?? '',
      statusPembayaran: data['statusPembayaran'] ?? '',
      location: data['location'] ?? '',
      namaPenjual: data['namaPenjual'] ?? '',
      noRekening: data['noRekening'] ?? '',
      buktiPembayaran: data['buktiPembayaran'] ?? '',
      isPemesan: data['isPemesan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCart': idCart,
      'image': image,
      'nama': nama,
      'harga': harga,
      'kategori': kategori,
      'usia': usia,
      'berat': berat,
      'lokasi': lokasi,
      'noHp': noHp,
      'status': status,
      'statusPengiriman': statusPengiriman,
      'statusPembayaran': statusPembayaran,
      'location': location,
      'namaPenjual': namaPenjual,
      'noRekening': noRekening,
      'buktiPembayaran': buktiPembayaran,
      'isPemesan': isPemesan,
    };
  }
}
