class User {
  final int id;
  final String username;
  final String namaLengkap;
  final String email;
  final String role;
  final String fotoUrl;

  User({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.email,
    required this.role,
    required this.fotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()) ?? 0,
      username: json['username'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      fotoUrl: json['foto_url'] ?? '',
    );
  }
}