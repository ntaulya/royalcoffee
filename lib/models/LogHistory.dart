class LogHistory {
  final String idCheckout;
  final String statusPemesanan;
  final String imagePath;
  final DateTime createdAt;
  final int jumlahItem;

  LogHistory({
    required this.idCheckout,
    required this.statusPemesanan,
    required this.imagePath,
    required this.createdAt,
    required this.jumlahItem,
  });

  factory LogHistory.fromJson(Map<String, dynamic> json) {
    return LogHistory(
      idCheckout: json['id_checkout'] ?? '',
      statusPemesanan: json['status_pemesanan'] ?? '',
      imagePath: json['image_path'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      jumlahItem: json['jumlah_item'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_checkout": idCheckout,
      "status_pemesanan": statusPemesanan,
      "image_path": imagePath,
      "created_at": createdAt.toIso8601String(),
      "jumlah_item": jumlahItem,
    };
  }
}
