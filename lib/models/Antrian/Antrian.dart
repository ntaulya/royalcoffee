class Antrian {
  final String idCheckout;
  final String namaUser;
  final String proces;
  final String create_at;

  Antrian({
    required this.idCheckout,
    required this.namaUser,
    required this.proces,
    required this.create_at,
  });

  factory Antrian.fromJson(Map<String, dynamic> json) {
    return Antrian(
      idCheckout: json['id_checkout'],
      namaUser: json['nama_user'],
      proces: json['proces'],
      create_at : json['create_at'],
    );
  }
}
