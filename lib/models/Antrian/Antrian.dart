class Antrian {
  final String idCheckout;
  final String namaUser;
  final String proces;
  final String tipePemesanan;
  final String create_at;

  Antrian({
    required this.idCheckout,
    required this.namaUser,
    required this.proces,
    required this.create_at,
    required this.tipePemesanan,
  });

  factory Antrian.fromJson(Map<String, dynamic> json) {
    return Antrian(
      idCheckout: json['id_checkout'] ?? '',
      namaUser: json['nama_user'] ?? '',
      proces: json['proces'] ?? '',
      create_at: json['create_at'] ?? '',
      tipePemesanan: json['tipe_pemesanan'].toString() ?? '',
    );
  }
}
