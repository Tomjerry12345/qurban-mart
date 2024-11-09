import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String? id,
      idProduk,
      pembeli,
      // image,
      // nama,
      // kategori,
      // noHp;
      // status,
      // statusPengiriman,
      statusPembayaran;
  // namaPenjual,
  // noRekening,
  // buktiPembayaran;
  // final GeoPoint? lokasi;
  // final int? harga, usia, berat;

  Cart({
    this.id,
    this.idProduk,
    this.pembeli,
    // this.image,
    // this.nama,
    // this.usia,
    // this.berat,
    // this.harga,
    // this.kategori,
    // this.lokasi,
    // this.noHp,
    // this.status,
    // this.statusPengiriman,
    this.statusPembayaran,
    // this.namaPenjual,
    // this.noRekening,
    // this.buktiPembayaran
  });

  factory Cart.fromMap(Map<String, dynamic> data) {
    return Cart(
      id: data['id'] ?? '',
      idProduk: data['idProduk'] ?? '',
      pembeli: data['pembeli'] ?? '',
      // nama: data['nama'] ?? '',
      // harga: data['harga'] ?? 0,
      // kategori: data['kategori'] ?? '',
      // usia: data['usia'] ?? 0,
      // berat: data['berat'] ?? 0,
      // lokasi: data['lokasi'],
      // noHp: data['noHp'] ?? '',
      // image: data['image'] ?? '',
      // status: data['status'] ?? '',
      // statusPengiriman: data['statusPengiriman'] ?? '',
      statusPembayaran: data['statusPembayaran'] ?? '',
      // namaPenjual: data['namaPenjual'] ?? '',
      // noRekening: data['noRekening'] ?? '',
      // buktiPembayaran: data['buktiPembayaran'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idProduk': idProduk,
      // 'pembeli': pembeli,
      // 'image': image,
      // 'nama': nama,
      // 'harga': harga,
      // 'kategori': kategori,
      // 'usia': usia,
      // 'berat': berat,
      // 'lokasi': lokasi,
      // 'noHp': noHp,
      // 'status': status, // Pastikan status di sini jika diperlukan
      // 'statusPengiriman': statusPengiriman,
      'statusPembayaran': statusPembayaran,
      // 'namaPenjual': namaPenjual,
      // 'noRekening': noRekening,
      // 'buktiPembayaran': buktiPembayaran,
    };
  }
}
