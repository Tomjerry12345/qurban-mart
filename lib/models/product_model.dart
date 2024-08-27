import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id, image, nama, kategori, noHp, status;
  final GeoPoint? lokasi;
  final int? harga, usia, berat;

  Product(
      {this.id,
      this.image,
      this.nama,
      this.usia,
      this.berat,
      this.harga,
      this.kategori,
      this.lokasi,
      this.noHp,
      this.status});

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      nama: data['nama'] ?? '',
      harga: data['harga'] ?? 0,
      kategori: data['kategori'] ?? '',
      usia: data['usia'] ?? 0,
      berat: data['berat'] ?? 0,
      lokasi: data['location'],
      noHp: data['noHp'] ?? '',
      image: data['image'] ?? '',
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'nama': nama,
      'harga': harga,
      'kategori': kategori,
      'usia': usia,
      'berat': berat,
      'lokasi': lokasi,
      'noHp': noHp,
      'status': status, // Pastikan status di sini jika diperlukan
    };
  }
}
