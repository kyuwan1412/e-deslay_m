import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'update_email_screen.dart';

class ProfileScreen extends StatefulWidget {

  final VoidCallback onBackToHome;

  const ProfileScreen({
    super.key,
    required this.onBackToHome,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  String nama = '';
  String username = '';
  String role = '';
  String email = '';
  String foto = '';

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  // ================= LOAD USER =================
  Future<void> loadUser() async {

    final user =
    await SessionService.getUser();

    setState(() {

      nama = user['nama'] ?? '';

      username =
          user['username'] ?? '';

      role = user['role'] ?? '';

      email = user['email'] ?? '';

      foto = user['foto'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        // ================= BG =================
        Positioned.fill(
          child: Image.asset(
            "assets/images/bgprofil.png",
            fit: BoxFit.cover,
          ),
        ),

        SafeArea(
          child: Column(
            children: [

              // ================= HEADER =================
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),

                child: Stack(
                  alignment: Alignment.center,

                  children: [

                    const Text(
                      "PROFILE SAYA",

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    Align(
                      alignment:
                      Alignment.centerLeft,

                      child: GestureDetector(
                        onTap:
                        widget.onBackToHome,

                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ================= FOTO =================
              Container(
                width: 130,
                height: 130,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.grey[300],

                  border: Border.all(
                    color: Colors.black54,
                    width: 1.5,
                  ),
                ),

                child: ClipOval(

                  child: foto.isNotEmpty

                      ? Image.network(
                    foto,
                    fit: BoxFit.cover,

                    errorBuilder:
                        (_, __, ___) {

                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.black54,
                      );
                    },
                  )

                      : const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ================= NAMA =================
              Text(
                nama,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 4),

              // ================= USERNAME =================
              Text(
                username,

                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              // ================= ROLE =================
              Text(
                role,

                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 40),

              // ================= CARD =================
              Container(
                width:
                MediaQuery.of(context)
                    .size
                    .width *
                    0.85,

                padding:
                const EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  18,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                      14),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),

                child: Column(
                  children: [

                    const Align(
                      alignment:
                      Alignment.centerLeft,

                      child: Text(
                        "Pengaturan akun",

                        style: TextStyle(
                          fontWeight:
                          FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= EDIT PROFILE =================
                    GestureDetector(
                      onTap: () async {

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );

                        if (result == true) {
                          await loadUser();
                        }
                      },

                      child: _item(
                        Icons.person,
                        "Ubah Profil",
                      ),
                    ),

                    // ================= PASSWORD =================
                    GestureDetector(
                      onTap: () async {

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ChangePasswordScreen(),
                          ),
                        );

                        await loadUser();
                      },

                      child: _item(
                        Icons.lock,
                        "Ubah Kata Sandi",
                      ),
                    ),

                    // ================= EMAIL =================
                    _item(
                      Icons.email,
                      "Perbarui Email",

                      onTap: () async {

                        final result =
                        await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                UpdateEmailScreen(
                                  currentEmail:
                                  email,
                                ),
                          ),
                        );

                        if (result == true) {
                          await loadUser();
                        }
                      },
                    ),

                    const SizedBox(height: 25),

                    // ================= LOGOUT =================
                    Align(
                      alignment:
                      Alignment.centerRight,

                      child: GestureDetector(
                        onTap: () =>
                            _showLogoutDialog(
                                context),

                        child: Container(
                          width: 110,
                          height: 36,

                          decoration:
                          BoxDecoration(

                            gradient:
                            const LinearGradient(
                              colors: [
                                Color(0xFF4FACFE),
                                Color(0xFF00C6FF),
                              ],
                            ),

                            borderRadius:
                            BorderRadius.circular(
                                10),
                          ),

                          child: const Center(
                            child: Text(
                              "KELUAR",

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  // ================= LOGOUT =================
  void _showLogoutDialog(
      BuildContext context) {

    showDialog(
      context: context,

      builder: (dialogContext) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),

          title: const Text(
            "Konfirmasi Logout",

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            "Apakah kamu yakin ingin keluar?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
              ),

              onPressed: () async {

                await SessionService.logout();

                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },

              child: const Text(
                "Keluar",
              ),
            )
          ],
        );
      },
    );
  }

  // ================= ITEM =================
  static Widget _item(
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(
        margin:
        const EdgeInsets.only(bottom: 12),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),

        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),

          borderRadius:
          BorderRadius.circular(10),

          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              color: Colors.grey,
              size: 20,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            )
          ],
        ),
      ),
    );
  }
}