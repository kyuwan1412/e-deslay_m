import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../services/firebase_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final namaController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool showPass = false;
  bool showConfirm = false;
  bool isLoading = false;

  void register() async {

    if (namaController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Semua field wajib diisi",
          ),
        ),
      );

      return;
    }

    // ================= PASSWORD CHECK =================

    if (passwordController.text !=
        confirmController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Konfirmasi password tidak sama",
          ),
        ),
      );

      return;
    }

    setState(() => isLoading = true);

    // ================= REGISTER =================

    final regResult =
    await ApiService.register(

      namaController.text,
      usernameController.text,
      emailController.text,
      passwordController.text,
    );

    // ================= REGISTER GAGAL =================

    if (regResult['success'] != true) {

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            regResult['message'] ??
                "Register gagal",
          ),
        ),
      );

      return;
    }

    // ================= AUTO LOGIN =================

    final loginResult =
    await ApiService.login(

      usernameController.text,
      passwordController.text,
    );

    // ================= LOGIN GAGAL =================

    if (loginResult['success'] != true) {

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loginResult['message'] ??
                "Login gagal",
          ),
        ),
      );

      return;
    }

    // ================= USER =================

    final user =
    loginResult['user'];

    // ================= AMBIL FCM TOKEN =================

    final fcmToken =
    await FirebaseService.getToken();

// ================= SAVE SESSION =================

    await SessionService.saveUser(

      id: user.id,

      username: user.username,

      email: user.email,

      nama: user.namaLengkap,

      role: user.role,

      foto: user.fotoUrl,

      fcmToken: fcmToken ?? '',
    );

// ================= SAVE FCM TOKEN =================

    await ApiService.saveFcmToken(

      userId: user.id,

      fcmToken: fcmToken ?? '',
    );

    // ================= PINDAH DASHBOARD =================

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(

      context,

      '/dashboard',

          (route) => false,
    );
  }

  Widget label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  );

  Widget inputField(TextEditingController controller,
      {bool isPassword = false, bool isConfirm = false}) {

    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword
            ? (isConfirm ? !showConfirm : !showPass)
            : false,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(height: 1.2),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isConfirm
                  ? (showConfirm
                  ? Icons.visibility
                  : Icons.visibility_off)
                  : (showPass
                  ? Icons.visibility
                  : Icons.visibility_off),
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  showConfirm = !showConfirm;
                } else {
                  showPass = !showPass;
                }
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDDE6F3),
                  Color(0xFFEDE5F6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// SHAPE KIRI
          Positioned(
            left: -200,
            top: 80,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// SHAPE KANAN
          Positioned(
            right: -200,
            bottom: 80,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 4),

                  /// 🔥 BACK BUTTON SUPER KE KIRI
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// 🔥 TITLE NAIK KE ATAS
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "DAFTAR AKUN",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E6BD6),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Buat akun untuk mulai menggunakan layanan informasi\n"
                              "dan pelayanan desa secara digital melalui E-Deslay",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  label("Nama Lengkap"),
                  inputField(namaController),

                  const SizedBox(height: 14),

                  label("Nama Pengguna"),
                  inputField(usernameController),

                  const SizedBox(height: 14),

                  label("Email"),
                  inputField(emailController),

                  const SizedBox(height: 14),

                  label("Kata Sandi"),
                  inputField(passwordController, isPassword: true),

                  const SizedBox(height: 14),

                  label("Konfirmasi Kata Sandi"),
                  inputField(confirmController,
                      isPassword: true, isConfirm: true),

                  const SizedBox(height: 32),

                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 52,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : InkWell(
                        onTap: register,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2F66D0),
                                Color(0xFF5B8CFF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "DAFTAR",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}