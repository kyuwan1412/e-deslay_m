import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final TextEditingController oldPasswordController =
  TextEditingController();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isLoading = false;

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  // ================= VALIDASI =================
  void validateAndConfirm() {

    if (oldPasswordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sandi lama wajib diisi",
          ),
        ),
      );

      return;
    }

    if (newPasswordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sandi baru wajib diisi",
          ),
        ),
      );

      return;
    }

    if (newPasswordController.text.length < 6) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sandi minimal 6 karakter",
          ),
        ),
      );

      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Konfirmasi sandi wajib diisi",
          ),
        ),
      );

      return;
    }

    if (newPasswordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Konfirmasi sandi tidak cocok",
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
            "Yakin ingin merubah kata sandi?",
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
                backgroundColor: Colors.blue,
              ),

              onPressed: () {

                Navigator.pop(context);

                changePassword();
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

  // ================= CHANGE PASSWORD =================
  Future<void> changePassword() async {

    setState(() {
      isLoading = true;
    });

    try {

      // 🔥 AMBIL SESSION USER
      final user = await SessionService.getUser();

      // 🔥 HIT API
      final result = await ApiService.changePassword(
        id: user['id'],

        oldPassword:
        oldPasswordController.text.trim(),

        newPassword:
        newPasswordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      // 🔥 JIKA GAGAL
      if (result['success'] != true) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ??
                  "Gagal mengubah password",
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      // 🔥 SUCCESS
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Kata sandi berhasil diperbarui",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
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
                  "UBAH KATA SANDI",

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
                  "Gunakan untuk memperbarui kata sandi akun\n"
                      "Anda yang terdaftar di layanan desa",

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

              // ================= OLD PASSWORD =================
              const Text(
                "Masukkan sandi lama",

                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                  color:
                  Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 10),

              _passwordField(
                controller:
                oldPasswordController,

                isVisible:
                oldPasswordVisible,

                onTap: () {

                  setState(() {
                    oldPasswordVisible =
                    !oldPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ================= NEW PASSWORD =================
              const Text(
                "Masukkan sandi baru",

                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                  color:
                  Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 10),

              _passwordField(
                controller:
                newPasswordController,

                isVisible:
                newPasswordVisible,

                onTap: () {

                  setState(() {
                    newPasswordVisible =
                    !newPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ================= CONFIRM PASSWORD =================
              const Text(
                "Konfirmasi sandi baru",

                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                  color:
                  Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 10),

              _passwordField(
                controller:
                confirmPasswordController,

                isVisible:
                confirmPasswordVisible,

                onTap: () {

                  setState(() {
                    confirmPasswordVisible =
                    !confirmPasswordVisible;
                  });
                },
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
                            color:
                            Colors.white,
                            strokeWidth:
                            2,
                          ),
                        )

                            : const Text(
                          "SIMPAN",

                          style:
                          TextStyle(
                            color:
                            Colors.white,
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

  // ================= PASSWORD FIELD =================
  Widget _passwordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onTap,
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

        obscureText: !isVisible,

        textAlignVertical:
        TextAlignVertical.center,

        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
          height: 1.2,
        ),

        decoration: InputDecoration(

          border: InputBorder.none,

          isCollapsed: true,

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
          ),

          suffixIcon: IconButton(
            onPressed: onTap,

            icon: Icon(
              isVisible
                  ? Icons.visibility
                  : Icons.visibility_off,

              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}