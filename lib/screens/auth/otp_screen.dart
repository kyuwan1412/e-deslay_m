import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  bool isLoading = false;

  int countdown = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String getOtp() {
    return controllers.map((e) => e.text).join();
  }

  void nextFocus(int index) {
    if (index < 5) {
      FocusScope.of(context).nextFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void startTimer() {
    countdown = 60;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown == 0) {
        t.cancel();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  /// 🔥 AMBIL OTP DARI CLIPBOARD (PASTI WORK)
  Future<void> tryPasteFromClipboard(String email) async {
    final data = await Clipboard.getData('text/plain');

    if (data != null && data.text != null) {
      String text = data.text!.replaceAll(RegExp(r'[^0-9]'), '');

      if (text.length >= 6) {
        for (int i = 0; i < 6; i++) {
          controllers[i].text = text[i];
        }

        /// auto verify
        verifyOtp(email);
      }
    }
  }

  /// 🔥 VERIFY OTP KE BACKEND
  Future<void> verifyOtp(String email) async {

    String otp = getOtp();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan 6 digit kode")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.verifyOtp(email, otp);

    setState(() => isLoading = false);

    if (result['success']) {
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: {
          "email": email,
          "otp": otp,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "OTP salah")),
      );
    }
  }

  Future<void> resendOtp(String email) async {

    if (countdown > 0) return;

    final result = await ApiService.sendOtp(email);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP dikirim ulang")),
      );
      startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

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
            children: [

              const SizedBox(height: 20),

              Text(
                "MASUKKAN KODE OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Kami telah mengirimkan kode 6 digit ke email Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 58,
                    child: TextField(
                      controller: controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      /// 🔥 KUNCI UTAMA DI SINI
                      onTap: () {
                        if (index == 0) {
                          tryPasteFromClipboard(email);
                        }
                      },

                      onChanged: (value) {
                        if (value.isNotEmpty) nextFocus(index);
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                  onTap: () => verifyOtp(email),
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
                        "LANJUTKAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              GestureDetector(
                onTap: () => resendOtp(email),
                child: Text(
                  countdown > 0
                      ? "Kirim ulang dalam $countdown detik"
                      : "Kirim Ulang",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}