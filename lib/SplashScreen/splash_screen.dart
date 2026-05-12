import 'dart:async';
import 'package:flutter/material.dart';

import '../services/session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {

  Timer? _timer;

  bool _hasNavigated = false;

  late AnimationController
  _logoController;

  late AnimationController
  _textController;

  late Animation<double>
  _logoScale;

  late Animation<double>
  _logoOpacity;

  late Animation<Offset>
  _textOffset;

  late Animation<double>
  _textOpacity;

  @override
  void initState() {
    super.initState();

    // ================= LOGO ANIMATION =================
    _logoController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(
            milliseconds: 1400,
          ),
        );

    _logoScale =
        Tween<double>(
          begin: 0.6,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _logoController,
            curve:
            Curves.easeOutBack,
          ),
        );

    _logoOpacity =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _logoController,
            curve:
            Curves.easeIn,
          ),
        );

    // ================= TEXT ANIMATION =================
    _textController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(
            milliseconds: 1200,
          ),
        );

    _textOffset =
        Tween<Offset>(
          begin:
          const Offset(
            0,
            0.5,
          ),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _textController,
            curve:
            Curves.easeOut,
          ),
        );

    _textOpacity =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _textController,
            curve:
            Curves.easeIn,
          ),
        );

    // START ANIMATION
    _logoController.forward();

    Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
          () {
        _textController.forward();
      },
    );

    // TIMER
    _timer = Timer(
      const Duration(seconds: 3),
      goToMain,
    );
  }

  Future<void> goToMain() async {

    if (_hasNavigated) return;

    _hasNavigated = true;

    bool isLoggedIn =
    await SessionService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {

      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
      );

    } else {

      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    }
  }

  @override
  void dispose() {

    _timer?.cancel();

    _logoController.dispose();

    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: goToMain,

      child: Scaffold(
        body: Stack(
          children: [

            // ================= BACKGROUND =================
            Container(
              width: double.infinity,
              height: double.infinity,

              decoration:
              const BoxDecoration(
                gradient:
                LinearGradient(
                  begin:
                  Alignment.topCenter,

                  end:
                  Alignment.bottomCenter,

                  colors: [
                    Color(0xFF2E6BE6),
                    Color(0xFF6FA4FF),
                    Color(0xFFEAF2FF),
                  ],
                ),
              ),
            ),

            // ================= CIRCLE GLOW =================
            Positioned(
              top: -80,
              right: -60,

              child: Container(
                width: 220,
                height: 220,

                decoration:
                BoxDecoration(
                  shape:
                  BoxShape.circle,

                  color: Colors.white
                      .withOpacity(
                    0.15,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -60,

              child: Container(
                width: 250,
                height: 250,

                decoration:
                BoxDecoration(
                  shape:
                  BoxShape.circle,

                  color: Colors.white
                      .withOpacity(
                    0.12,
                  ),
                ),
              ),
            ),

            // ================= CONTENT =================
            Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,

                children: [

                  // ================= LOGO =================
                  FadeTransition(
                    opacity:
                    _logoOpacity,

                    child: ScaleTransition(
                      scale:
                      _logoScale,

                      child: Container(
                        padding:
                        const EdgeInsets.all(
                          20,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withOpacity(
                            0.18,
                          ),

                          shape:
                          BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.25,
                              ),

                              blurRadius:
                              25,

                              spreadRadius:
                              5,
                            )
                          ],
                        ),

                        child: Image.asset(
                          'assets/images/logonganjuk.png',

                          width: 120,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ================= TEXT =================
                  FadeTransition(
                    opacity:
                    _textOpacity,

                    child:
                    SlideTransition(
                      position:
                      _textOffset,

                      child: const Column(
                        children: [

                          Text(
                            "E-Deslay",

                            style:
                            TextStyle(
                              fontSize:
                              34,

                              color:
                              Colors.white,

                              fontFamily:
                              'LemonShake',

                              fontStyle:
                              FontStyle
                                  .italic,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Layanan Digital Desa Modern",

                            style:
                            TextStyle(
                              color:
                              Colors.white70,

                              fontSize:
                              14,

                              letterSpacing:
                              0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // ================= LOADING =================
                  SizedBox(
                    width: 28,
                    height: 28,

                    child:
                    CircularProgressIndicator(
                      strokeWidth:
                      3,

                      color:
                      Colors.white
                          .withOpacity(
                        0.9,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    "Memuat aplikasi...",

                    style: TextStyle(
                      color:
                      Colors.white70,

                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ================= TAP SKIP =================
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,

              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.15,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      30,
                    ),
                  ),

                  child: const Text(
                    "Tap untuk lanjut",

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}