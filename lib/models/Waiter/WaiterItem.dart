class WaiterItem {
  final String idCheckout;
  final String idVarian;
  final String namaPemesan;
  final String namaProduct;
  final String namaVarian;
  final String tipePemesanan;
  final String status;
  final String imagePath;
  final String createAt;
  final String pesan;
  final int item;

  WaiterItem({
    required this.idCheckout,
    required this.idVarian,
    required this.namaPemesan,
    required this.namaProduct,
    required this.namaVarian,
    required this.status,
    required this.imagePath,
    required this.item,
    required this.tipePemesanan,
    required this.createAt,
    required this.pesan,
  });

  factory WaiterItem.fromJson(Map<String, dynamic> json) {
    return WaiterItem(
      idCheckout: json['id_checkout'] ?? '',
      idVarian: (json['id_varian'] ?? 0).toString(),
      namaPemesan: json['nama_pemesan'] ?? '',
      namaProduct: json['nama_product'] ?? '',
      namaVarian: json['nama_varian'] ?? '',
      status: json['status'] ?? '',
      imagePath: json['image_path'] ?? '',
      item: int.parse(json['item'].toString()) ?? 0,
      tipePemesanan : json['status_pemesanan'].toString() ?? '',
      createAt : json['create_at'].toString() ?? '',
      pesan: json['note'].toString() ?? '',
    );
  }
}
