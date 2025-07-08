class ItemProduct {
  final String product_id;
  final String varian_id;
  final String nama_product;
  final String nama_varian;
  final int qty;
  final double harga_satuan;
  final double harga_total;

  ItemProduct({
    required this.product_id,
    required this.varian_id,
    required this.nama_product,
    required this.nama_varian,
    required this.qty,
    required this.harga_satuan,
    required this.harga_total,
  });

  factory ItemProduct.fromJson(Map<String, dynamic> json){  
    return ItemProduct(
        product_id: json['product_id'],
        varian_id: json['varian_id'],
        nama_product: json['nama_product'],
        nama_varian: json['nama_varian'],
        qty: json['qty'],
        harga_satuan: json['harga_satuan'],
        harga_total: json['harga_total'],
    );
  }
}
