class ItemProduct {
  final String product_id;
  final String varian_id;
  final String nama_product;
  final String nama_varian;
  final int qty;
  final double harga_stauan;
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

  factrory ItemProduct.fromJson(Map<String, dynamic> json){  
    return Item(
        product_id: json['product_id'],
        varian_id: json['varian_id'],
        nama_product: json['nama_product'],
        nama_varian: json['nama_varian'],
        qty: json['qty'],
        harga_stauan: json['harga_satuan'],
        harga_total: json['harga_total'],
    );
  }
}
