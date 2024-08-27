import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id, image, nama, kategori, lokasi, noHp, status;
  final int? harga, usia, berat;
  final GeoPoint? location;

  Product({
    this.id,
    this.image,
    this.nama,
    this.usia,
    this.berat,
    this.harga,
    this.kategori,
    this.lokasi,
    this.noHp,
    this.status,
    this.location,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      nama: data['nama'] ?? '',
      harga: data['harga'] ?? 0,
      kategori: data['kategori'] ?? '',
      usia: data['usia'] ?? 0,
      berat: data['berat'] ?? 0,
      lokasi: data['lokasi'] ?? '',
      noHp: data['noHp'] ?? '',
      image: data['image'] ?? '',
      status: data['status'] ?? '',
      location: data['location'] ?? '',
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
      'status': status,
      'location': location
    };
  }
}

List demoProducts = [
  Product(
      image: "assets/icons/xd_file.svg",
      nama: "Kambing",
      usia: 2,
      berat: 3,
      harga: 200000,
      kategori: "Kurban",
      lokasi: "Bulukumba",
      noHp: "085753845575"),
];
