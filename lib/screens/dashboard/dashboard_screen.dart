import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/session_service.dart';

import '../../services/api_service.dart';
import '../kegiatan/kegiatan_screen.dart';
import '../surat/sktm/sktm_screen.dart';
import '../surat/domisili/domisili_screen.dart';
import '../surat/penghasilan/penghasilan_screen.dart';
import '../surat/kelahiran/kelahiran_screen.dart';
import '../surat/ktp/ktp_screen.dart';
import '../surat/kematian/kematian_screen.dart';
import '../surat/izin/izin_screen.dart';
import '../surat/nikah/nikah_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onSeeAllKegiatan;

  const DashboardScreen({
    super.key,
    this.onSeeAllKegiatan,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int userId = 0;

  List<Map<String, dynamic>>
  kegiatanTerbaru = [];

  bool isLoadingKegiatan = true;

  final TextEditingController
  searchController =
  TextEditingController();

  List<Map<String, dynamic>>
  menuLayanan = [];

  List<Map<String, dynamic>>
  filteredMenu = [];

  @override
  void initState() {
    super.initState();

    getUserSession();
    getKegiatanTerbaru();

    initMenu();
  }

  // ================= INIT MENU =================
  void initMenu() {

    menuLayanan = [

      {
        "title": "Domisili",
        "image":
        "assets/images/domisili.png",
        "screen":
            (context) =>
            DomisiliScreen(
              userId: userId,
            ),
      },

      {
        "title": "SKTM",
        "image":
        "assets/images/ikon_sktm.png",
        "screen":
            (context) =>
            SKTMScreen(
              userId: userId,
            ),
      },

      {
        "title": "Penghasilan",
        "image":
        "assets/images/penghasilan.png",
        "screen":
            (context) =>
            PenghasilanScreen(
              userId: userId,
            ),
      },

      {
        "title": "Kelahiran",
        "image":
        "assets/images/kelahiran.png",
        "screen":
            (context) =>
            KelahiranScreen(
              userId: userId,
            ),
      },

      {
        "title": "KTP",
        "image":
        "assets/images/ktp.png",
        "screen":
            (context) =>
            KtpScreen(
              userId: userId,
            ),
      },

      {
        "title": "Kematian",
        "image":
        "assets/images/kematian.png",
        "screen":
            (context) =>
            KematianScreen(
              userId: userId,
            ),
      },

      {
        "title": "Izin",
        "image":
        "assets/images/izin.png",
        "screen":
            (context) =>
            IzinScreen(
              userId: userId,
            ),
      },

      {
        "title": "Nikah",
        "image":
        "assets/images/nikah.png",
        "screen":
            (context) =>
            NikahScreen(
              userId: userId,
            ),
      },
    ];

    filteredMenu = menuLayanan;
  }

  // ================= SEARCH MENU =================
  void searchMenu(String keyword) {

    setState(() {

      filteredMenu =
          menuLayanan.where((menu) {

            return menu['title']
                .toString()
                .toLowerCase()
                .contains(
              keyword.toLowerCase(),
            );
          }).toList();
    });
  }

  Future<void> getUserSession() async {

    final user =
    await SessionService.getUser();

    setState(() {

      userId = user['id'];
    });

    print("LOGIN USER ID : $userId");
  }

  // ================= GET KEGIATAN =================
  Future<void>
  getKegiatanTerbaru() async {

    setState(() {
      isLoadingKegiatan = true;
    });

    final response =
    await ApiService.getKegiatan();

    if (response['success'] == true) {

      final data =
      List<Map<String, dynamic>>.from(
        response['data'],
      );

      setState(() {

        kegiatanTerbaru =
            data.take(2).toList();

        isLoadingKegiatan = false;
      });

    } else {

      setState(() {
        isLoadingKegiatan = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<
        SystemUiOverlayStyle>(

      value:
      const SystemUiOverlayStyle(
        statusBarIconBrightness:
        Brightness.light,

        statusBarColor:
        Colors.transparent,
      ),

      child: Scaffold(
        backgroundColor:
        const Color(0xFFF4F6F9),

        body: SingleChildScrollView(
          child: Column(
            children: [

              _header(),

              Transform.translate(
                offset:
                const Offset(0, -20),

                child: Column(
                  children: [

                    _layananCard(),

                    const SizedBox(
                      height: 12,
                    ),

                    _terbaruCard(),

                    const SizedBox(
                      height: 12,
                    ),

                    _banner(),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.fromLTRB(
        16,
        45,
        16,
        20,
      ),

      decoration:
      const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E4DB7),
            Color(0xFF2E6BE6),
          ],
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              Image.asset(
                "assets/images/logonganjuk.png",
                width: 42,
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Container(
                  height: 42,

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      25,
                    ),
                  ),

                  child: TextField(
                    controller:
                    searchController,

                    onChanged:
                    searchMenu,

                    textAlignVertical:
                    TextAlignVertical
                        .center,

                    decoration:
                    const InputDecoration(
                      hintText:
                      "Cari layanan...",

                      border:
                      InputBorder.none,

                      isDense: true,

                      prefixIcon:
                      Icon(
                        Icons.search,
                        size: 20,
                      ),

                      contentPadding:
                      EdgeInsets.symmetric(
                        vertical:
                        10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            "SELAMAT DATANG DI LAYANAN\nDESA BANJARDOWO",

            textAlign:
            TextAlign.center,

            style: TextStyle(
              color:
              Colors.white,

              fontWeight:
              FontWeight.bold,

              fontSize: 15,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Row(
            mainAxisSize:
            MainAxisSize.min,

            children: [

              Image.asset(
                "assets/images/logoorang.png",
                width: 160,
              ),

              const SizedBox(
                width: 2,
              ),

              const Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    "Akses Layanan Desa Tanpa Ribet?",

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontSize: 12,
                    ),
                  ),

                  Text(
                    "E-Deslay Solusinya!",

                    style: TextStyle(
                      color:
                      Colors.yellow,

                      fontWeight:
                      FontWeight
                          .bold,

                      fontSize:
                      12,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // ================= LAYANAN =================
  Widget _layananCard() {

    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      padding:
      const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        10,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        boxShadow: const [
          BoxShadow(
            color:
            Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            "Pengajuan Surat Online",

            style: TextStyle(
              fontWeight:
              FontWeight.bold,

              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          GridView.builder(

            shrinkWrap: true,

            itemCount:
            filteredMenu.length,

            physics:
            const NeverScrollableScrollPhysics(),

            padding:
            EdgeInsets.zero,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 4,

              mainAxisSpacing: 2,

              crossAxisSpacing: 8,

              childAspectRatio: 0.95,
            ),

            itemBuilder:
                (context, index) {

              final menu =
              filteredMenu[index];

              return GestureDetector(

                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (context) =>
                          menu['screen'](
                            context,
                          ),
                    ),
                  );
                },

                child: _menu(
                  menu['title'],
                  menu['image'],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= MENU =================
  Widget _menu(
      String title,
      String image,
      ) {

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [

        // ================= ICON =================
        Image.asset(
          image,

          width: 50,
          height: 50,

          fit: BoxFit.contain,
        ),

        const SizedBox(
          height: 4,
        ),

        // ================= TITLE =================
        Text(
          title,

          textAlign:
          TextAlign.center,

          maxLines: 1,

          overflow:
          TextOverflow.ellipsis,

          style:
          const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  // ================= TERBARU =================
  Widget _terbaruCard() {

    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        boxShadow: const [
          BoxShadow(
            color:
            Colors.black12,
            blurRadius: 6,
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

            children: [

              const Text(
                "Terbaru Untukmu",

                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              GestureDetector(

                onTap: () {

                  if (widget.onSeeAllKegiatan != null) {

                    widget.onSeeAllKegiatan!();

                  } else {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const KegiatanScreen(),
                      ),
                    );
                  }
                },

                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.blue,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: const Text(
                    "Lihat Semua",

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontSize: 11,
                    ),
                  ),
                ),
              )
            ],
          ),

          const SizedBox(
            height: 4,
          ),

          const Text(
            "Kabar kegiatan desa terbaru akhir-akhir ini",

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          if (isLoadingKegiatan)

            const Center(
              child: Padding(
                padding:
                EdgeInsets.all(12),

                child:
                CircularProgressIndicator(
                  color:
                  Colors.blue,
                ),
              ),
            )

          else if (kegiatanTerbaru
              .isEmpty)

            const Padding(
              padding:
              EdgeInsets.all(12),

              child: Text(
                "Belum ada kegiatan terbaru",
              ),
            )

          else

            Column(
              children:
              kegiatanTerbaru.map(
                    (item) {

                  return _news(item);
                },
              ).toList(),
            ),
        ],
      ),
    );
  }

  // ================= NEWS =================
  Widget _news(
      Map<String, dynamic> item,
      ) {

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        children: [

          Stack(
            children: [

              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),

                child: Image.network(
                  item['foto_url'] ?? '',

                  width: 58,
                  height: 58,

                  fit: BoxFit.cover,

                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {

                    return Image.asset(
                      "assets/images/logonganjuk.png",

                      width: 58,
                      height: 58,
                    );
                  },
                ),
              ),

              Positioned(
                top: 0,
                right: 0,

                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),

                  decoration:
                  const BoxDecoration(
                    color: Colors.red,

                    borderRadius:
                    BorderRadius.only(
                      topRight:
                      Radius.circular(
                        12,
                      ),

                      bottomLeft:
                      Radius.circular(
                        8,
                      ),
                    ),
                  ),

                  child: const Text(
                    "BARU",

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontSize: 7,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(
                  item['judul'] ?? '-',

                  maxLines: 2,

                  overflow:
                  TextOverflow
                      .ellipsis,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  item['tanggal'] ?? '-',

                  style:
                  const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= BANNER =================
  Widget _banner() {

    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(
          15,
        ),

        child: Image.asset(
          "assets/images/banner.png",
        ),
      ),
    );
  }
}