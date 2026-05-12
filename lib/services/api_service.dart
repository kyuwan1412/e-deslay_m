import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {

  //  FIX BASE URL
  static const String baseUrl = "http://172.16.103.97:8000";

  /// ================= LOGIN =================
  static Future<Map<String, dynamic>> login(
      String identifier,
      String password,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/login"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "identifier": identifier,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true) {

        return {
          "success": true,
          "user": User.fromJson(data['user']),
        };

      } else {

        return {
          "success": false,
          "message": data['message'] ?? "Login gagal",
        };
      }

    } catch (e) {

      print("LOGIN ERROR: $e");

      return {
        "success": false,
        "message": "Koneksi gagal",
      };
    }
  }

  /// ================= SEND OTP =================
  static Future<Map<String, dynamic>> sendOtp(
      String email,
      ) async {

    try {

      final res = await http.post(
        Uri.parse("$baseUrl/api/send-otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
        },
      );

      print("SEND OTP: ${res.body}");

      return jsonDecode(res.body);

    } catch (e) {

      print("ERROR OTP: $e");

      return {
        "success": false,
        "message": "Gagal koneksi ke server",
      };
    }
  }

  /// ================= RESEND OTP =================
  static Future<Map<String, dynamic>> resendOtp(
      String email,
      ) async {

    try {

      final res = await http.post(
        Uri.parse("$baseUrl/api/resend-otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
        },
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {
        "success": false,
        "message": "Gagal resend OTP",
      };
    }
  }

  /// ================= VERIFY OTP =================
  static Future<Map<String, dynamic>> verifyOtp(
      String email,
      String otp,
      ) async {

    try {

      final res = await http.post(
        Uri.parse("$baseUrl/api/verify-otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "otp": otp,
        },
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {
        "success": false,
        "message": "Verifikasi OTP gagal",
      };
    }
  }

  /// ================= RESET PASSWORD =================
  static Future<Map<String, dynamic>> resetPassword(
      String email,
      String otp,
      String newPassword,
      ) async {

    try {

      final res = await http.post(
        Uri.parse("$baseUrl/api/reset-password"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "otp": otp,
          "new_password": newPassword,
        },
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {
        "success": false,
        "message": "Reset password gagal",
      };
    }
  }

  /// ================= REGISTER =================
  static Future<Map<String, dynamic>> register(
      String nama,
      String username,
      String email,
      String password,
      ) async {

    try {

      final response = await http.post(
        Uri.parse("$baseUrl/api/register"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "nama_lengkap": nama,
          "username": username,
          "email": email,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      return jsonDecode(response.body);

    } catch (e) {

      print("REGISTER ERROR: $e");

      return {
        "success": false,
        "message": "Koneksi gagal: $e",
      };
    }
  }

  /// ================= GET USER =================
  static Future<Map<String, dynamic>> getUser(int id) async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/api/user/$id"),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= UPDATE PROFILE =================
  static Future<Map<String, dynamic>> updateProfile({
    required int id,
    required String namaLengkap,
    required String username,
    File? foto,
  }) async {

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/api/update-profile"),
      );

      request.fields['id'] = id.toString();
      request.fields['nama_lengkap'] = namaLengkap;
      request.fields['username'] = username;

      if (foto != null) {

        final mimeType = lookupMimeType(foto.path)?.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            foto.path,
            contentType: MediaType(
              mimeType![0],
              mimeType[1],
            ),
          ),
        );
      }

      final response = await request.send();

      final responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= CHANGE PASSWORD =================
  static Future<Map<String, dynamic>> changePassword({
    required int id,
    required String oldPassword,
    required String newPassword,
  }) async {

    try {

      final response = await http.post(
        Uri.parse("$baseUrl/api/change-password"),

        body: {
          "id": id.toString(),
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
  // ================= UPDATE EMAIL =================
  static Future<Map<String, dynamic>> updateEmail({
    required int id,
    required String email,
  }) async {

    try {

      final response = await http.post(
        Uri.parse("$baseUrl/api/update-email"),

        headers: {
          "Accept": "application/json",
        },

        body: {
          "id": id.toString(),
          "email": email,
        },
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": "Koneksi gagal",
      };
    }
  }
  // =====================================================
  // ===================== SARAN ==========================
  // =====================================================

  /// ================= GET SARAN =================
  static Future<Map<String, dynamic>> getSaran(
      String email,
      ) async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/api/saran/$email"),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= TAMBAH SARAN =================
  static Future<Map<String, dynamic>> tambahSaran({
    required String email,
    required String judul,
    required String isiSaran,
    File? foto,
  }) async {

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/api/tambah-saran"),
      );

      request.fields['email'] = email;
      request.fields['judul'] = judul;
      request.fields['isi_saran'] = isiSaran;

      // ================= FOTO =================
      if (foto != null) {

        final mimeType =
        lookupMimeType(foto.path)?.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            foto.path,

            contentType: MediaType(
              mimeType![0],
              mimeType[1],
            ),
          ),
        );
      }

      final response = await request.send();

      final responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= DETAIL SARAN =================
  static Future<Map<String, dynamic>> detailSaran(
      int id,
      ) async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/api/detail-saran/$id"),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= UPDATE SARAN =================
  static Future<Map<String, dynamic>> updateSaran({
    required int id,
    required String judul,
    required String isiSaran,
    File? foto,
  }) async {

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/api/update-saran"),
      );

      request.fields['id'] = id.toString();
      request.fields['judul'] = judul;
      request.fields['isi_saran'] = isiSaran;

      // ================= FOTO =================
      if (foto != null) {

        final mimeType =
        lookupMimeType(foto.path)?.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            foto.path,

            contentType: MediaType(
              mimeType![0],
              mimeType[1],
            ),
          ),
        );
      }

      final response = await request.send();

      final responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= DELETE SARAN =================
  static Future<Map<String, dynamic>> deleteSaran(
      int id,
      ) async {

    try {

      final response = await http.delete(
        Uri.parse("$baseUrl/api/delete-saran/$id"),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
  // =====================================================
  // ==================== KEGIATAN =======================
  // =====================================================

  /// ================= GET KEGIATAN =================
  static Future<Map<String, dynamic>> getKegiatan() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/api/kegiatan"),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  /// ================= DETAIL KEGIATAN =================
  static Future<Map<String, dynamic>> detailKegiatan(
      int id,
      ) async {

    try {

      final response = await http.get(
        Uri.parse(
          "$baseUrl/api/detail-kegiatan/$id",
        ),
      );

      return jsonDecode(response.body);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}