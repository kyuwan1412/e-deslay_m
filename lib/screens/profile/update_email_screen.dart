import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';

class UpdateEmailScreen extends StatefulWidget {
  final String currentEmail;

  const UpdateEmailScreen({
    super.key,
    required this.currentEmail,
  });

  @override
  State<UpdateEmailScreen> createState() =>
      _UpdateEmailScreenState();
}

class _UpdateEmailScreenState
    extends State<UpdateEmailScreen> {

  late TextEditingController currentEmailController;

  final TextEditingController newEmailController =
  TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    currentEmailController =
        TextEditingController(
          text: widget.currentEmail,
        );
  }

  // ================= VALIDASI =================
  void validateAndConfirm() {

    final newEmail =
    newEmailController.text.trim();

    if (newEmail.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email baru wajib diisi",
          ),
        ),
      );

      return;
    }

    if (!newEmail.contains("@")) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Format email tidak valid",
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
            "Yakin ingin memperbarui email?",
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

                updateEmail();
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

  // ================= UPDATE EMAIL =================
  Future<void> updateEmail() async {

    setState(() {
      isLoading = true;
    });

    final user =
    await SessionService.getUser();

    final result =
    await ApiService.updateEmail(
      id: user['id'],
      email:
      newEmailController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {

      final updatedUser =
      result['user'];

      await SessionService.saveUser(
        id: updatedUser['id'],
        username:
        updatedUser['username'],
        email:
        updatedUser['email'],
        nama:
        updatedUser['nama_lengkap'],
        role:
        updatedUser['role'],
        foto:
        updatedUser['foto_url'] ?? '',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Email berhasil diperbarui",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

    } else {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
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
                  "PERBARUI EMAIL",

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
                  "Gunakan untuk memperbarui email akun\n"
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

              // ================= EMAIL SAAT INI =================
              const Text(
                "Email saat ini",

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
                currentEmailController,
                enabled: false,
              ),

              const SizedBox(height: 20),

              // ================= EMAIL BARU =================
              const Text(
                "Perbarui email",

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
                newEmailController,
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

  // ================= INPUT =================
  Widget _inputField({
    required TextEditingController controller,
    bool enabled = true,
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

        enabled: enabled,

        textAlignVertical:
        TextAlignVertical.center,

        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: enabled
              ? const Color(0xFF333333)
              : Colors.grey,
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