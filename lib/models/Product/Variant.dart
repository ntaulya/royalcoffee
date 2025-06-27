class Variant {
  final int idVarian;
  final String namaVarian;
  final String hargaTambahan;
  final String stock;
  final String imagePath;
  final bool isPrimary;

  Variant({
    required this.idVarian,
    required this.namaVarian,
    required this.hargaTambahan,
    required this.stock,
    required this.imagePath,
    required this.isPrimary,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      idVarian: json['id_varian'],
      namaVarian: json['nama_varian'],
      hargaTambahan: json['harga_tambahan'],
      stock: json['stock'],
      imagePath: json['image_path'],
      isPrimary: json['is_primary'] == 1,
    );
  }
}
