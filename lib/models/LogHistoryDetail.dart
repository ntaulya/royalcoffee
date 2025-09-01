class LogHistoryDetail {
  final String? namaLengkap;
  final String? tipePemesanan;
  final String? tipePembayaran;
  final DateTime createdAt;
  final double nominalPembayaran;
  final List<ItemProduct>? itemProduct;

  LogHistoryDetail({
    this.namaLengkap,
    this.tipePemesanan,
    this.tipePembayaran,
    required this.createdAt,
    required this.nominalPembayaran,
    this.itemProduct,
  });

  factory LogHistoryDetail.fromJson(Map<String, dynamic> json) {
    return LogHistoryDetail(
      namaLengkap: json['nama_lengkap'],
      tipePemesanan: json['tipe_pemesanan'],
      tipePembayaran: json['tipe_pembayaran'],
      createdAt: DateTime.parse(json['created_at']),
      nominalPembayaran: double.tryParse(json['nominal_pembayaran'].toString()) ?? 0.0,
      itemProduct: (json['item_product'] as List<dynamic>?)
          ?.map((e) => ItemProduct.fromJson(e))
          .toList(),
    );
  }
}


class ItemProduct {
  final String namaVarian;
  final String imagePath;
  final int qty;
  final double hargaTambahan;

  ItemProduct({
    required this.namaVarian,
    required this.imagePath,
    required this.qty,
    required this.hargaTambahan,
  });

  factory ItemProduct.fromJson(Map<String, dynamic> json) {
    return ItemProduct(
      namaVarian: json['nama_varian'] ?? '',
      imagePath: json['image_path'] ?? '',
      qty: int.tryParse(json['qty'].toString()) ?? 0,
      hargaTambahan: double.tryParse(json['harga_tambahan'].toString()) ?? 0.0,
    );
  }
}