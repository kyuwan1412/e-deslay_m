import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool isPasswordVisible = false;

  bool isLoading = false;

  /// AUTO LOGIN
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  void checkLogin() async {

    bool isLogin =
    await SessionService.isLoggedIn();

    if (isLogin && mounted) {

      Future.delayed(
        Duration.zero,
            () {

          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        },
      );
    }
  }

  /// POPUP
  void showPopup(
      String message, {

        bool success = false,
      }) {

    showDialog(

      context: context,

      builder: (_) => Dialog(

        shape: RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(16),
        ),

        child: Container(

          padding:
          const EdgeInsets.all(20),

          decoration: BoxDecoration(

            borderRadius:
            BorderRadius.circular(16),

            gradient: LinearGradient(

              colors:

              success

                  ? [
                Colors.green.shade400,
                Colors.green.shade600,
              ]

                  : [
                Colors.red.shade400,
                Colors.red.shade600,
              ],
            ),
          ),

          child: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              Icon(

                success

                    ? Icons.check_circle

                    : Icons.error,

                color: Colors.white,

                size: 50,
              ),

              const SizedBox(
                height: 12,
              ),

              Text(

                message,

                textAlign:
                TextAlign.center,

                style: const TextStyle(

                  color: Colors.white,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.white,

                  foregroundColor:

                  success

                      ? Colors.green

                      : Colors.red,
                ),

                onPressed: () {

                  Navigator.pop(context);
                },

                child: const Text(
                  "OK",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// LOGIN
  void login() async {

    String email =
    emailController.text.trim();

    String password =
    passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {

      showPopup(
        "Semua field wajib diisi",
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    final result =
    await ApiService.login(
      email,
      password,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    print(
      "LOGIN RESULT: $result",
    );

    if (result['success'] == true) {

      final user =
      result['user'];

      // ================= SAVE SESSION =================
      await SessionService.saveUser(

        id: user.id,

        username: user.username,

        email: user.email,

        nama: user.namaLengkap,

        role: user.role,

        foto: user.fotoUrl,

        fcmToken: '',
      );

      // ================= GET FCM TOKEN =================
      final fcmToken =
      await FirebaseMessaging
          .instance
          .getToken();

      print("FCM TOKEN:");
      print(fcmToken);

      // ================= SAVE TOKEN =================
      if (fcmToken != null) {

        final tokenResult =
        await ApiService.saveFcmToken(

          userId: user.id,
          fcmToken: fcmToken,
        );

        print("SAVE TOKEN RESULT:");
        print(tokenResult);
      }

      showPopup(
        "Login berhasil",
        success: true,
      );

      Future.delayed(

        const Duration(
          milliseconds: 800,
        ),

            () {

          if (mounted) {

            Navigator.pushReplacementNamed(
              context,
              '/dashboard',
            );
          }
        },
      );

    } else {

      showPopup(
        result['message']
            ?? "Login gagal",
      );
    }
  }

  Widget inputField({

    required TextEditingController
    controller,

    bool isPassword = false,
  }) {

    return Container(

      height: 48,

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(8),

        border: Border.all(
          color:
          Colors.grey.shade400,
        ),
      ),

      child: TextField(

        controller: controller,

        obscureText:

        isPassword

            ? !isPasswordVisible

            : false,

        textAlignVertical:
        TextAlignVertical.center,

        style:
        const TextStyle(
          fontSize: 14,
        ),

        keyboardType:
        TextInputType.text,

        textInputAction:
        TextInputAction.done,

        decoration: InputDecoration(

          isDense: true,

          border:
          InputBorder.none,

          contentPadding:
          const EdgeInsets.symmetric(

            horizontal: 12,
            vertical: 12,
          ),

          suffixIcon:

          isPassword

              ? IconButton(

            icon: Icon(

              isPasswordVisible

                  ? Icons.visibility

                  : Icons.visibility_off,

              color: Colors.grey,
            ),

            onPressed: () {

              setState(() {

                isPasswordVisible =
                !isPasswordVisible;
              });
            },
          )

              : null,
        ),
      ),
    );
  }

  Widget label(String text) {

    return Text(

      text,

      style: const TextStyle(

        fontWeight:
        FontWeight.bold,

        color: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset:
      false,

      body: Stack(

        children: [

          Column(

            children: [

              Expanded(

                flex: 5,

                child: Container(

                  decoration:
                  const BoxDecoration(

                    gradient:
                    LinearGradient(

                      colors: [

                        Color(0xFF2F66D0),

                        Color(0xFF4A86F0),
                      ],

                      begin:
                      Alignment.topCenter,

                      end:
                      Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Expanded(

                flex: 5,

                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Positioned(

            bottom: -20,
            left: -20,
            right: -20,

            child: SizedBox(

              height: 170,

              child: SvgPicture.asset(

                'assets/svg/wave.svg',

                fit: BoxFit.fill,
              ),
            ),
          ),

          SafeArea(

            child: SingleChildScrollView(

              padding: EdgeInsets.only(

                bottom:
                MediaQuery.of(context)
                    .viewInsets
                    .bottom +
                    20,
              ),

              child: Column(

                children: [

                  const SizedBox(
                    height: 60,
                  ),

                  Image.asset(

                    'assets/images/logonganjuk.png',

                    width: 110,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(

                    "DESA BANJARDOWO",

                    style: TextStyle(

                      color: Colors.white,

                      fontWeight:
                      FontWeight.bold,

                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  Container(

                    margin:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 20,
                      vertical: 25,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      const Color(
                        0xFFEDEDED,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.black.withOpacity(
                            0.25,
                          ),

                          blurRadius: 12,

                          offset:
                          const Offset(
                            0,
                            6,
                          ),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Center(

                          child: Text(

                            "Login\nLayanan Desa",

                            textAlign:
                            TextAlign.center,

                            style: TextStyle(

                              fontSize: 26,

                              fontWeight:
                              FontWeight.bold,

                              color:
                              Colors.blue.shade700,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        label(
                          "Nama Pengguna/Email",
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        inputField(
                          controller:
                          emailController,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        label(
                          "Kata Sandi",
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        inputField(

                          controller:
                          passwordController,

                          isPassword: true,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Align(

                          alignment:
                          Alignment.centerRight,

                          child: GestureDetector(

                            onTap: () {

                              Navigator.pushNamed(
                                context,
                                '/forgot-password',
                              );
                            },

                            child: Text(

                              "Lupa Kata Sandi?",

                              style: TextStyle(

                                color:
                                Colors.blue.shade700,

                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        SizedBox(

                          width:
                          double.infinity,

                          height: 48,

                          child:

                          isLoading

                              ? const Center(

                            child:
                            CircularProgressIndicator(),
                          )

                              : InkWell(

                            onTap: login,

                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),

                            child: Container(

                              decoration:
                              const BoxDecoration(

                                gradient:
                                LinearGradient(

                                  colors: [

                                    Color(0xFF2F66D0),

                                    Color(0xFF5B8CFF),
                                  ],
                                ),

                                borderRadius:
                                BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                              ),

                              child:
                              const Center(

                                child: Text(

                                  "MASUK",

                                  style: TextStyle(

                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        Center(

                          child: GestureDetector(

                            onTap: () {

                              Navigator.pushNamed(
                                context,
                                '/register',
                              );
                            },

                            child: RichText(

                              text: TextSpan(

                                text:
                                "Belum punya akun? ",

                                style:
                                const TextStyle(
                                  color:
                                  Colors.black,
                                ),

                                children: [

                                  TextSpan(

                                    text:
                                    "Daftar Sekarang",

                                    style: TextStyle(

                                      color:
                                      Colors.blue.shade700,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}