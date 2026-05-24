import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final TextEditingController namaController =
  TextEditingController();

  final TextEditingController usernameController =
  TextEditingController();

  File? imageFile;

  bool isLoading = false;

  int userId = 0;

  String fotoUrl = "";

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  // ================= LOAD USER =================
  Future<void> loadUser() async {

    final session =
    await SessionService.getUser();

    userId = session['id'];

    final result =
    await ApiService.getUser(userId);

    if (result['success'] == true) {

      final user = result['user'];

      namaController.text =
          user['nama_lengkap'] ?? '';

      usernameController.text =
          user['username'] ?? '';

      fotoUrl =
          user['foto_url'] ?? '';

      setState(() {});
    }
  }

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {

    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {

      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // ================= VALIDASI =================
  void validateAndConfirm() {

    if (namaController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Nama lengkap wajib diisi",
          ),
        ),
      );

      return;
    }

    if (usernameController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Nama pengguna wajib diisi",
          ),
        ),
      );

      return;
    }

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),

          title: const Text(
            "Konfirmasi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            "Yakin ingin merubah profil?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Batal",
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.blue,
              ),

              onPressed: () {

                Navigator.pop(context);

                updateProfile();
              },

              child: const Text(
                "Ya",
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= UPDATE PROFILE =================
  Future<void> updateProfile() async {

    try {

      setState(() {
        isLoading = true;
      });

      final result =
      await ApiService.updateProfile(

        id: userId,

        namaLengkap:
        namaController.text.trim(),

        username:
        usernameController.text.trim(),

        foto: imageFile,
      );

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {

        final user =
        result['user'];

        final oldSession =
        await SessionService.getUser();

        // ================= UPDATE SESSION =================

        await SessionService.saveUser(

          id: user['id'],

          username: user['username'],

          email: user['email'],

          nama: user['nama_lengkap'],

          role: user['role'],

          foto: user['foto_url'],

          fcmToken:
          oldSession['fcmToken'] ?? '',
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Profil berhasil diperbarui",
            ),

            backgroundColor:
            Colors.green,
          ),
        );

        Navigator.pop(context, true);

      } else {

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: Text(
              result['message'] ??
                  "Gagal update profil",
            ),

            backgroundColor:
            Colors.red,
          ),
        );
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "ERROR: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F5F5),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ================= BACK =================
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: const Icon(
                  Icons.arrow_back,
                  size: 27,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // ================= TITLE =================
              const Center(
                child: Text(
                  "PERBARUI PROFIL ANDA",

                  textAlign:
                  TextAlign.center,

                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                    FontWeight.w900,
                    color:
                    Color(0xFF222222),
                    letterSpacing: -0.5,
                    height: 1,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ================= SUBTITLE =================
              const Center(
                child: Text(
                  "Gunakan untuk memperbarui Nama Lengkap, Nama Pengguna\n"
                      "dan Foto Profil Anda yang terdaftar di layanan desa",

                  textAlign:
                  TextAlign.center,

                  style: TextStyle(
                    fontSize: 11.5,
                    color:
                    Color(0xFF707070),
                    fontWeight:
                    FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 42),

              // ================= NAMA =================
              const Text(
                "Nama lengkap",

                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                  color:
                  Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 10),

              _inputField(
                controller: namaController,
              ),

              const SizedBox(height: 20),

              // ================= USERNAME =================
              const Text(
                "Nama pengguna",

                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                  color:
                  Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 10),

              _inputField(
                controller:
                usernameController,
              ),

              const SizedBox(height: 20),

              // ================= FOTO =================
              const Text(
                "Foto profil",

                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                  color:
                  Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: pickImage,

                child: Container(
                  width: double.infinity,
                  height: 165,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                        4),

                    border: Border.all(
                      color: const Color(
                          0xFFC9C9C9),
                    ),
                  ),

                  child: imageFile != null

                  // FOTO BARU
                      ? ClipRRect(
                    borderRadius:
                    BorderRadius
                        .circular(
                        4),

                    child: Image.file(
                      imageFile!,
                      fit:
                      BoxFit.cover,
                    ),
                  )

                  // FOTO DB
                      : fotoUrl.isNotEmpty

                      ? ClipRRect(
                    borderRadius:
                    BorderRadius
                        .circular(
                        4),

                    child:
                    Image.network(
                      fotoUrl,
                      fit: BoxFit
                          .cover,
                    ),
                  )

                  // DEFAULT
                      : const Center(
                    child: Icon(
                      Icons
                          .image_outlined,
                      size: 46,
                      color: Color(
                          0xFF444444),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 50,

                child: Container(

                  decoration:
                  BoxDecoration(

                    gradient:
                    const LinearGradient(
                      colors: [
                        Color(
                            0xFF2E65D3),
                        Color(
                            0xFF4E83FF),
                      ],
                    ),

                    borderRadius:
                    BorderRadius
                        .circular(
                        10),

                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .blue
                            .withOpacity(
                            0.25),

                        blurRadius: 10,

                        offset:
                        const Offset(
                            0, 4),
                      )
                    ],
                  ),

                  child: Material(
                    color:
                    Colors.transparent,

                    child: InkWell(

                      borderRadius:
                      BorderRadius
                          .circular(10),

                      onTap: isLoading
                          ? null
                          : validateAndConfirm,

                      child: Center(

                        child: isLoading

                            ? const SizedBox(
                          width: 20,
                          height: 20,

                          child:
                          CircularProgressIndicator(
                            color: Colors
                                .white,
                            strokeWidth:
                            2,
                          ),
                        )

                            : const Text(
                          "SIMPAN",

                          style:
                          TextStyle(
                            color: Colors
                                .white,
                            fontWeight:
                            FontWeight
                                .w800,
                            fontSize:
                            13,
                            letterSpacing:
                            0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _inputField({
    required TextEditingController
    controller,
  }) {

    return Container(
      height: 45,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(4),

        border: Border.all(
          color:
          const Color(0xFFC9C9C9),
          width: 1,
        ),
      ),

      child: TextField(

        controller: controller,

        textAlignVertical:
        TextAlignVertical.center,

        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
          height: 1.2,
        ),

        decoration: const InputDecoration(

          border: InputBorder.none,

          isCollapsed: true,

          contentPadding:
          EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
          ),
        ),
      ),
    );
  }
}