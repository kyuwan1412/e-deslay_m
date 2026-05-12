import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final passController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;
  bool showPass = false;
  bool showConfirm = false;

  void reset(String email, String otp) async {

    String pass = passController.text;
    String confirm = confirmController.text;

    /// VALIDASI
    if (pass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kata Sandi minimal 8 karakter")),
      );
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi Kata Sandi tidak sama")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.resetPassword(
        email, otp, pass);

    setState(() => isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil direset")),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final email = args['email'];
    final otp = args['otp'];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 40),

              /// 🔥 TITLE (DIBESARKAN + SHADOW)
              Center(
                child: Text(
                  "Kata Sandi Baru",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 🔥 LABEL PASSWORD
              const Text(
                "Masukkan Kata Sandi Baru",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔥 INPUT PASSWORD (FIX CENTER)
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: passController,
                  obscureText: !showPass,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// 🔥 INFO
              const Text(
                "Gunakan minimal 8 karakter.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 LABEL KONFIRMASI
              const Text(
                "Konfirmasi Kata Sandi Baru",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔥 INPUT KONFIRMASI (FIX CENTER)
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: confirmController,
                  obscureText: !showConfirm,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          showConfirm = !showConfirm;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Pastikan sama persis dengan kata sandi baru di atas.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 35),

              /// 🔥 BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2F66D0),
                        Color(0xFF5B8CFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => reset(email, otp),
                    child: const Center(
                      child: Text(
                        "SIMPAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}