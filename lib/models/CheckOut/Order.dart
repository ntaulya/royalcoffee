import './ItemProduct.dart';

class Order {
  final String id;
  final String? email;
  final String nama_pemesan;
  final String tipe_pemesanan;
  final String create_at;
  final String? catatan;
  final List<ItemProduct>? Item;

  Order({
    required this.id,
    required this.nama_pemesan,
    required this.tipe_pemesanan,
    required this.create_at,
    this.email,
    this.catatan,
    this.Item,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id_checkout']?.toString() ?? '',
      email: json['email']?.toString(),
      nama_pemesan: json['nama_lengkap']?.toString() ?? '',
      tipe_pemesanan: json['tipe_pemesanan']?.toString() ?? '',
      create_at: json['created_at']?.toString() ?? '',
      catatan: json['notes']?.toString(),
      Item: (json['item_product'] is List)
          ? (json['item_product'] as List)
              .map((v) => ItemProduct.fromJson(v))
              .toList()
          : null,
    );
  }
}
