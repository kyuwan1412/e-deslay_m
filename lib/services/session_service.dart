import 'package:shared_preferences/shared_preferences.dart';

class SessionService {

  // ================= SAVE USER =================
  static Future<void> saveUser({
    required int id,
    required String username,
    required String email,
    required String nama,
    required String role,
    required String foto,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('id', id);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('nama', nama);
    await prefs.setString('role', role);
    await prefs.setString('foto', foto);

    await prefs.setBool('isLogin', true);
  }

  // ================= CHECK LOGIN =================
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // ================= GET USER =================
  static Future<Map<String, dynamic>> getUser() async {

    final prefs = await SharedPreferences.getInstance();

    return {
      "id": prefs.getInt('id') ?? 0,
      "username": prefs.getString('username') ?? '',
      "email": prefs.getString('email') ?? '',
      "nama": prefs.getString('nama') ?? '',
      "role": prefs.getString('role') ?? '',
      "foto": prefs.getString('foto') ?? '',
    };
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}