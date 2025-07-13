class ItemProduct {
  final String product_id;
  final String varian_id;
  final String nama_product;
  final String nama_varian;
  final int qty;
  final double harga_satuan;
  final double harga_total;
  final String? image;

  ItemProduct({
    required this.product_id,
    required this.varian_id,
    required this.nama_product,
    required this.nama_varian,
    required this.qty,
    required this.harga_satuan,
    required this.harga_total,
    this.image = "",
  });

  factory ItemProduct.fromJson(Map<String, dynamic> json){  
    return ItemProduct(
        product_id: json['product_id'],
        varian_id: json['varian_id'],
        nama_product: json['nama_product'],
        nama_varian: json['nama_varian'],
        qty: int.tryParse(json['qty'].toString()) ?? 0,
        harga_satuan: double.tryParse(json['harga_satuan'].toString()) ?? 0.0,
        harga_total: double.tryParse(json['harga_total'].toString()) ?? 0.0,
    );
  }
}
