import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {

  //  FIX BASE URL
  static const String baseUrl = "https://edeslay.pbltifnganjuk.com";

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

  // ================= PENGAJUAN SKTM =================
  static Future<Map<String, dynamic>>
  submitSKTM({

    required String userId,
    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,
    required String jumlahTanggungan,
    required String statusEkonomi,
    required String tujuanSktm,
    required String metodePengambilan,
    required String filePath,

  }) async {

    try {

      var uri = Uri.parse(
        "$baseUrl/api/pengajuan-sktm",
      );

      var request =
      http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_lengkap'] =
          namaLengkap;

      request.fields['nik'] =
          nik;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['jumlah_tanggungan'] =
          jumlahTanggungan;

      request.fields['status_ekonomi'] =
          statusEkonomi;

      request.fields['tujuan_sktm'] =
          tujuanSktm;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(

        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      print(response.statusCode);

      print(responseData);

      return jsonDecode(
        responseData,
      );

    } catch (e) {

      print(e);

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }

  // ================= GET RIWAYAT SKTM =================
  static Future<Map<String, dynamic>>
  getRiwayatSKTM(int userId) async {

    try {

      final response = await http.get(
        Uri.parse(
          "$baseUrl/api/pengajuan-sktm/user/$userId",
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
  // ================= SUBMIT DOMISILI =================
  static Future submitDomisili({

    required String userId,
    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,
    required String tempatTinggal,
    required String keperluan,
    required String metodePengambilan,
    required String filePath,

  }) async {

    var uri = Uri.parse(
      "$baseUrl/api/pengajuan-domisili",
    );

    var request =
    http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields['user_id'] =
        userId;

    request.fields['nama_lengkap'] =
        namaLengkap;

    request.fields['nik'] =
        nik;

    request.fields['no_hp'] =
        noHp;

    request.fields['alamat'] =
        alamat;

    request.fields['tanggal_pengajuan'] =
        tanggalPengajuan;

    request.fields['tempat_tinggal'] =
        tempatTinggal;

    request.fields['keperluan'] =
        keperluan;

    request.fields['metode_pengambilan'] =
        metodePengambilan;

    request.files.add(
      await http.MultipartFile.fromPath(
        'dokumen_scan',
        filePath,
      ),
    );

    var response =
    await request.send();

    var responseData =
    await response.stream.bytesToString();

    return jsonDecode(responseData);
  }
  // ================= SUBMIT PENGHASILAN =================
  static Future<Map<String, dynamic>>
  submitPenghasilan({

    required String userId,
    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,
    required String pekerjaan,
    required String jumlahPenghasilan,
    required String jumlahTanggungan,
    required String tujuanPengajuan,
    required String metodePengambilan,
    required String filePath,

  }) async {

    try {

      var uri = Uri.parse(
        "$baseUrl/api/pengajuan-penghasilan",
      );

      var request =
      http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_lengkap'] =
          namaLengkap;

      request.fields['nik'] =
          nik;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['pekerjaan'] =
          pekerjaan;

      request.fields['jumlah_penghasilan'] =
          jumlahPenghasilan;

      request.fields['jumlah_tanggungan'] =
          jumlahTanggungan;

      request.fields['tujuan_pengajuan'] =
          tujuanPengajuan;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(

        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(
        responseData,
      );

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= SUBMIT KELAHIRAN =================
  static Future<Map<String, dynamic>>
  submitKelahiran({

    required String userId,
    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,

    required String namaBayi,
    required String tempatLahirBayi,
    required String tanggalLahirBayi,
    required String jenisKelaminBayi,
    required String waktuLahir,

    required String namaAyah,
    required String namaIbu,
    required String nikAyah,
    required String nikIbu,

    required String metodePengambilan,
    required String filePath,

  }) async {

    try {

      var uri = Uri.parse(
        "$baseUrl/api/pengajuan-kelahiran",
      );

      var request =
      http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_lengkap'] =
          namaLengkap;

      request.fields['nik'] =
          nik;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['nama_bayi'] =
          namaBayi;

      request.fields['tempat_lahir_bayi'] =
          tempatLahirBayi;

      request.fields['tanggal_lahir_bayi'] =
          tanggalLahirBayi;

      request.fields['jenis_kelamin_bayi'] =
          jenisKelaminBayi;

      request.fields['waktu_lahir'] =
          waktuLahir;

      request.fields['nama_ayah'] =
          namaAyah;

      request.fields['nama_ibu'] =
          namaIbu;

      request.fields['nik_ayah'] =
          nikAyah;

      request.fields['nik_ibu'] =
          nikIbu;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(

        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= SUBMIT KTP =================
  static Future<Map<String, dynamic>>
  submitKtp({

    required String userId,
    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,
    required String jenisPermohonan,
    required String alasanPermohonan,
    required String metodePengambilan,
    required String filePath,
  }) async {

    try {

      var uri = Uri.parse(
        '$baseUrl/api/pengajuan-ktp',
      );

      var request =
      http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_lengkap'] =
          namaLengkap;

      request.fields['nik'] =
          nik;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['jenis_permohonan'] =
          jenisPermohonan;

      request.fields['alasan_permohonan'] =
          alasanPermohonan;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(

        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= SUBMIT KEMATIAN =================
  static Future<Map<String, dynamic>>
  submitKematian({

    required String userId,
    required String namaPelapor,
    required String nikPelapor,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,
    required String namaAlmarhum,
    required String nikAlmarhum,
    required String tempatKematian,
    required String tanggalKematian,
    required String sebabKematian,
    required String hubunganPelapor,
    required String metodePengambilan,
    required String filePath,

  }) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/pengajuan-kematian',
        ),
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_pelapor'] =
          namaPelapor;

      request.fields['nik_pelapor'] =
          nikPelapor;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['nama_almarhum'] =
          namaAlmarhum;

      request.fields['nik_almarhum'] =
          nikAlmarhum;

      request.fields['tempat_kematian'] =
          tempatKematian;

      request.fields['tanggal_kematian'] =
          tanggalKematian;

      request.fields['sebab_kematian'] =
          sebabKematian;

      request.fields['hubungan_pelapor'] =
          hubunganPelapor;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(

        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {

        'success': false,

        'message': e.toString(),
      };
    }
  }
  // ================= SUBMIT IZIN =================
  static Future<Map<String, dynamic>>
  submitIzin({

    required String userId,
    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,
    required String tanggalPengajuan,
    required String namaKegiatan,
    required String lokasiKegiatan,
    required String tanggalKegiatan,
    required String waktuKegiatan,
    required String penanggungJawab,
    required String metodePengambilan,
    required String filePath,

  }) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/pengajuan-izin',
        ),
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_lengkap'] =
          namaLengkap;

      request.fields['nik'] =
          nik;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['nama_kegiatan'] =
          namaKegiatan;

      request.fields['lokasi_kegiatan'] =
          lokasiKegiatan;

      request.fields['tanggal_kegiatan'] =
          tanggalKegiatan;

      request.fields['waktu_kegiatan'] =
          waktuKegiatan;

      request.fields['penanggung_jawab'] =
          penanggungJawab;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(

        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {

        'success': false,

        'message': e.toString(),
      };
    }
  }
  // ================= SUBMIT NIKAH =================
  static Future<Map<String, dynamic>>
  submitNikah({

    required String userId,

    required String namaLengkap,
    required String nik,
    required String noHp,
    required String alamat,

    required String tanggalPengajuan,

    required String namaSuami,
    required String namaIstri,

    required String nikSuami,
    required String nikIstri,

    required String alamatMasing2,

    required String tanggalRencana,

    required String lokasiNikah,

    required String namaPj,

    required String metodePengambilan,

    required String filePath,

  }) async {

    try {

      var uri = Uri.parse(
        '$baseUrl/api/pengajuan-nikah',
      );

      var request =
      http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['user_id'] =
          userId;

      request.fields['nama_lengkap'] =
          namaLengkap;

      request.fields['nik'] =
          nik;

      request.fields['no_hp'] =
          noHp;

      request.fields['alamat'] =
          alamat;

      request.fields['tanggal_pengajuan'] =
          tanggalPengajuan;

      request.fields['nama_suami'] =
          namaSuami;

      request.fields['nama_istri'] =
          namaIstri;

      request.fields['nik_suami'] =
          nikSuami;

      request.fields['nik_istri'] =
          nikIstri;

      request.fields['alamat_masing2'] =
          alamatMasing2;

      request.fields['tanggal_rencana'] =
          tanggalRencana;

      request.fields['lokasi_nikah'] =
          lokasiNikah;

      request.fields['nama_pj'] =
          namaPj;

      request.fields['metode_pengambilan'] =
          metodePengambilan;

      request.files.add(
        await http.MultipartFile.fromPath(
          'dokumen_scan',
          filePath,
        ),
      );

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= GET DOMISILI USER =================
  static Future<Map<String, dynamic>>
  getDomisiliByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-domisili/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }

// ================= GET SKTM USER =================
  static Future<Map<String, dynamic>>
  getSKTMByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-sktm/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }
  // ================= GET KELAHIRAN =================
  static Future<Map<String, dynamic>>
  getKelahiranByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-kelahiran/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }

// ================= GET KTP =================
  static Future<Map<String, dynamic>>
  getKtpByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-ktp/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }

// ================= GET PENGHASILAN =================
  static Future<Map<String, dynamic>>
  getPenghasilanByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-penghasilan/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }

// ================= GET KEMATIAN =================
  static Future<Map<String, dynamic>>
  getKematianByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-kematian/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }

// ================= GET IZIN =================
  static Future<Map<String, dynamic>>
  getIzinByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-izin/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }

// ================= GET NIKAH =================
  static Future<Map<String, dynamic>>
  getNikahByUser(
      int userId,
      ) async {

    final response =
    await http.get(
      Uri.parse(
        '$baseUrl/api/pengajuan-nikah/user/$userId',
      ),
    );

    return jsonDecode(
      response.body,
    );
  }
  // ================= RIWAYAT =================
  static Future<Map<String, dynamic>>
  getRiwayat(int userId) async {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/riwayat/$userId',
      ),
    );

    return jsonDecode(response.body);
  }

// ================= DELETE RIWAYAT =================
  static Future<Map<String, dynamic>>
  deleteRiwayat(
      String jenis,
      int id,
      ) async {

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/api/riwayat/$jenis/$id',
      ),
    );

    return jsonDecode(response.body);
  }
  // ================= BASE URL IMAGE =================
  static const String baseUrlImage =
      "$baseUrl";

// ================= DETAIL RIWAYAT =================
  static Future<Map<String, dynamic>>
  getRiwayatDetail(
      String jenis,
      int id,
      ) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/riwayat/$jenis/$id',
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
  // ================= UPDATE SKTM =================
  static Future<Map<String, dynamic>>
  updateSKTM(

      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/update-sktm/$id',
        ),
      );

      request.fields.addAll({

        "nama_lengkap":
        data['nama_lengkap'],

        "nik":
        data['nik'],

        "no_hp":
        data['no_hp'],

        "alamat":
        data['alamat'],

        "jumlah_tanggungan":
        data['jumlah_tanggungan'],

        "status_ekonomi":
        data['status_ekonomi'],

        "tujuan_skmt":
        data['tujuan_skmt'],
      });

      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(
        res.body,
      );

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= UPDATE DOMISILI =================
  static Future<Map<String, dynamic>>
  updateDomisili(

      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/update-domisili/$id',
        ),
      );

      request.fields.addAll({

        "nama_lengkap":
        data['nama_lengkap'],

        "nik":
        data['nik'],

        "no_hp":
        data['no_hp'],

        "alamat":
        data['alamat'],

        "tempat_tinggal":
        data['tempat_tinggal'],

        "keperluan":
        data['keperluan'],

        "metode_pengambilan":
        data['metode_pengambilan'],
      });

      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(
        res.body,
      );

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= UPDATE KTP =================
  static Future<Map<String, dynamic>>
  updateKtp(

      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/ktp/update/$id',
        ),
      );

      request.fields.addAll({

        "nama_lengkap":
        data['nama_lengkap'],

        "nik":
        data['nik'],

        "no_hp":
        data['no_hp'],

        "alamat":
        data['alamat'],

        "jenis_permohonan":
        data['jenis_permohonan'],

        "alasan_permohonan":
        data['alasan_permohonan'],

        "metode_pengambilan":
        data['metode_pengambilan'],
      });

      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(
        res.body,
      );

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= UPDATE KELAHIRAN =================
  static Future<Map<String, dynamic>>
  updateKelahiran(
      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          "$baseUrl/api/kelahiran/update/$id",
        ),
      );

      data.forEach((key, value) {

        if (key != "dokumen_scan") {

          request.fields[key] =
              value.toString();
        }
      });

      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',
            data['dokumen_scan'],
          ),
        );
      }

      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      return jsonDecode(responseData);

    } catch (e) {

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
  // ================= UPDATE PENGHASILAN =================
  static Future<Map<String, dynamic>>
  updatePenghasilan(
      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/penghasilan/update/$id',
        ),
      );

      data.forEach((key, value) async {

        if (key != 'dokumen_scan') {

          request.fields[key] =
              value.toString();
        }
      });

      // ================= FILE =================
      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= UPDATE KEMATIAN =================
  static Future<Map<String, dynamic>>
  updateKematian(
      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/kematian/update/$id',
        ),
      );

      data.forEach((key, value) {

        if (key != 'dokumen_scan') {

          request.fields[key] =
              value.toString();
        }
      });

      // ================= FILE =================
      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= UPDATE IZIN =================
  static Future<Map<String, dynamic>>
  updateIzin(
      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/izin/update/$id',
        ),
      );

      data.forEach((key, value) {

        if (key != 'dokumen_scan') {

          request.fields[key] =
              value.toString();
        }
      });

      // ================= FILE =================
      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= UPDATE NIKAH =================
  static Future<Map<String, dynamic>>
  updateNikah(
      int id,
      Map<String, dynamic> data,
      ) async {

    try {

      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/api/nikah/update/$id',
        ),
      );

      data.forEach((key, value) {

        if (key != 'dokumen_scan') {

          request.fields[key] =
              value.toString();
        }
      });

      // ================= FILE =================
      if (data['dokumen_scan'] != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'dokumen_scan',

            data['dokumen_scan'],
          ),
        );
      }

      final response =
      await request.send();

      final res =
      await http.Response.fromStream(
        response,
      );

      return jsonDecode(res.body);

    } catch (e) {

      return {

        'success': false,
        'message': e.toString(),
      };
    }
  }
  // ================= SAVE FCM TOKEN =================
  static Future<Map<String, dynamic>>
  saveFcmToken({

    required int userId,
    required String fcmToken,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(
          '$baseUrl/api/save-fcm-token',
        ),

        headers: {
          "Accept": "application/json",
        },

        body: {

          "user_id":
          userId.toString(),

          "fcm_token":
          fcmToken,
        },
      );

      return jsonDecode(
        response.body,
      );

    } catch (e) {

      return {

        "success": false,
        "message": e.toString(),
      };
    }
  }
  static const String storageUrl =
      "https://edeslay.pbltifnganjuk.com/storage";
}