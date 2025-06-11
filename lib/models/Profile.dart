class Profile {
  final String email;
  final String namaLengkap;
  final String phone;
  final List<String> ? role;

  Profile({
    required this.email,
    required this.namaLengkap,
    required this.phone,
    this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] != null ? List<String>.from(json['role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nama_lengkap': namaLengkap,
      'phone': phone,
      'role': role,
    };
  }

  Profile copyWith({
    String? email,
    String? namaLengkap,
    String? phone,
    List<String>? role,
  }) {
    return Profile(
      email: email ?? this.email,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'Profile(email: $email, namaLengkap: $namaLengkap, phone: $phone, role: $role)';
  }
}