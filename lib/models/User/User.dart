class User {
  final String id;
  final String email;
  final String namaLengkap;
  final String phone;
  User({
    required this.id,
    required this.email,
    required this.namaLengkap,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}