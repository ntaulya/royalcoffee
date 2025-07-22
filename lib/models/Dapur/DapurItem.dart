class DapurItem {
  final String idCheckout;
  final String idVarian;
  final String namaPemesan;
  final String namaProduct;
  final String namaVarian;
  final String tipePemesanan;
  final String status;
  final String imagePath;
  final String createAt;
  final int item;

  DapurItem({
    required this.idCheckout,
    required this.idVarian,
    required this.namaPemesan,
    required this.namaProduct,
    required this.namaVarian,
    required this.status,
    required this.imagePath,
    required this.tipePemesanan,
    required this.createAt,
    required this.item,
  });

  factory DapurItem.fromJson(Map<String, dynamic> json) {
    return DapurItem(
      idCheckout: json['id_checkout'] ?? '',
      idVarian: json['id_varian'].toString() ?? '0',
      namaPemesan: json['nama_pemesan'] ?? '',
      namaProduct: json['nama_product'] ?? '',
      namaVarian: json['nama_varian'] ?? '',
      status: json['status'] ?? '',
      imagePath: json['image_path'] ?? '',
      item: json['item'] ?? 0,
      tipePemesanan : json['status_pemesanan'] ?? '',
      createAt : json['create_at'] ?? '',
    );
  }
}
