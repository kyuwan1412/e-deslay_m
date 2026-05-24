import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dashboard/dashboard_screen.dart';
import 'profile/profile_screen.dart';
import 'saran/saran_screen.dart';
import 'kegiatan/kegiatan_screen.dart';
import 'riwayat/riwayat_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int _index = 0;

  // ================= SIMPAN HALAMAN SEBELUM PROFILE =================
  int _lastIndexBeforeProfile = 0;

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.description_rounded,
    Icons.mail_outline_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = [
    "Beranda",
    "Kegiatan",
    "Riwayat",
    "Saran",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {

    // ================= PAGES =================
    final List<Widget> _pages = [

      // ================= DASHBOARD =================
      DashboardScreen(
        onSeeAllKegiatan: () {
          setState(() {
            _index = 1;
          });
        },
      ),

      // ================= KEGIATAN =================
      const KegiatanScreen(),

      // ================= RIWAYAT =================
      const RiwayatScreen(),

      // ================= SARAN =================
      const SaranScreen(),

      // ================= PROFIL =================
      ProfileScreen(

        // ================= KEMBALI KE HALAMAN SEBELUMNYA =================
        onBackToHome: () {

          setState(() {

            _index =
                _lastIndexBeforeProfile;
          });
        },
      ),
    ];

    return Scaffold(

      body: AnimatedSwitcher(
        duration:
        const Duration(
          milliseconds: 250,
        ),

        child: _pages[_index],
      ),

      // ================= FIX NAVBAR SEMUA HP =================
      bottomNavigationBar: SafeArea(

        top: false,

        minimum:
        const EdgeInsets.only(
          bottom: 4,
        ),

        child: Container(
          height: 65,

          padding:
          const EdgeInsets.symmetric(
            horizontal: 8,
          ),

          decoration:
          const BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color:
                Colors.black12,

                blurRadius: 10,

                offset:
                Offset(0, -2),
              )
            ],
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,

            children: List.generate(
              _icons.length,
                  (i) {

                final isActive =
                    _index == i;

                return GestureDetector(

                  onTap: () {

                    HapticFeedback
                        .lightImpact();

                    setState(() {

                      // ================= SIMPAN PAGE SEBELUM PROFILE =================
                      if (i == 4 &&
                          _index != 4) {

                        _lastIndexBeforeProfile =
                            _index;
                      }

                      _index = i;
                    });
                  },

                  child: SizedBox(
                    width: 60,

                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                      children: [

                        AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds:
                            250,
                          ),

                          transform:
                          Matrix4.translationValues(
                            0,
                            isActive
                                ? -4
                                : 0,
                            0,
                          ),

                          child:
                          AnimatedScale(
                            duration:
                            const Duration(
                              milliseconds:
                              250,
                            ),

                            scale:
                            isActive
                                ? 1.2
                                : 1.0,

                            child: Icon(
                              _icons[i],

                              size: 24,

                              color:
                              isActive
                                  ? const Color(
                                0xFF2E6BE6,
                              )
                                  : Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        AnimatedOpacity(
                          duration:
                          const Duration(
                            milliseconds:
                            200,
                          ),

                          opacity:
                          isActive
                              ? 1
                              : 0,

                          child: Text(
                            _labels[i],

                            style:
                            const TextStyle(
                              fontSize:
                              10,

                              fontWeight:
                              FontWeight
                                  .w600,

                              color:
                              Color(
                                0xFF2E6BE6,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds:
                            250,
                          ),

                          width:
                          isActive
                              ? 4
                              : 0,

                          height: 4,

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFF2E6BE6,
                            ),

                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}