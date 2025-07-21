class WaiterItem {
  final String idCheckout;
  final String idVarian;
  final String namaPemesan;
  final String namaProduct;
  final String namaVarian;
  final String status;
  final String imagePath;
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
      item: int.tryParse(json['item'].toString()) ?? 0,
    );
  }
}
