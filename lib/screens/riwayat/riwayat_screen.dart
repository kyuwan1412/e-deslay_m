import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';
import 'detail_riwayat_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() =>
      _RiwayatScreenState();
}

class _RiwayatScreenState
    extends State<RiwayatScreen> {

  String selectedJenis = "all";

  String search = "";

  bool isLoading = false;

  List<Map<String, dynamic>>
  dataRiwayat = [];

  @override
  void initState() {
    super.initState();

    getRiwayat();
  }

  // ================= GET RIWAYAT =================
  Future<void> getRiwayat() async {

    setState(() {
      isLoading = true;
    });

    try {

      final user =
      await SessionService.getUser();

      final userId =
      user['id'];

      final response =
      await ApiService.getRiwayat(
        userId,
      );

      if (response['success'] == true) {

        final List<dynamic> rawData =
        response['data'];

        final List<Map<String, dynamic>>
        temp = [];

        temp.clear();
        for (var item in rawData) {

          final map =
          Map<String, dynamic>.from(item);

          Color warna =
              Colors.blue;

          IconData icon =
              Icons.description;

          switch (map['jenis']) {

            case "Surat Domisili":

              warna =
              const Color(
                0xFF4CAF50,
              );

              icon =
                  Icons.home_rounded;

              break;

            case "Surat Keterangan Tidak Mampu":

              warna =
              const Color(
                0xFF7E57C2,
              );

              icon =
                  Icons.description_rounded;

              break;

            case "Pengantar KTP":

              warna =
              const Color(
                0xFF2979FF,
              );

              icon =
                  Icons.badge;

              break;

            case "Surat Kelahiran":

              warna =
              const Color(
                0xFFFF5C8D,
              );

              icon =
                  Icons.child_care;

              break;

            case "Surat Penghasilan":

              warna =
              const Color(
                0xFF00ACC1,
              );

              icon =
                  Icons.payments;

              break;

            case "Surat Kematian":

              warna =
              const Color(
                0xFFEF5350,
              );

              icon =
                  Icons.favorite;

              break;

            case "Surat Izin":

              warna =
              const Color(
                0xFFFF9800,
              );

              icon =
                  Icons.event_note;

              break;

            case "Surat Nikah":

              warna =
              const Color(
                0xFFE91E63,
              );

              icon =
                  Icons.favorite_border;

              break;
          }

          temp.add({

            ...map,

            "warna": warna,

            "icon": icon,
          });
        }

        setState(() {

          dataRiwayat =
              temp;

          isLoading = false;
        });

      } else {

        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      debugPrint(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final filtered =
    dataRiwayat.where((e) {

      final keyword =
      search.toLowerCase();

      final cocokSearch =

          e['jenis']
              .toString()
              .toLowerCase()
              .contains(keyword)

              ||

              (e['tanggal'] ?? '')
                  .toString()
                  .contains(keyword);

      final cocokJenis =
      selectedJenis == "all"

          ? true

          : e['jenis'] ==
          selectedJenis;

      return cocokSearch &&
          cocokJenis;

    }).toList();

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F6FA),

      body: Stack(

        children: [

          // ================= CONTENT =================
          Column(
            children: [

              _header(),

              Expanded(

                child: RefreshIndicator(

                  onRefresh: getRiwayat,

                  child:

                  filtered.isEmpty

                      ? ListView(

                    physics:
                    const AlwaysScrollableScrollPhysics(),

                    children: const [

                      SizedBox(
                        height: 150,
                      ),

                      Center(
                        child: Text(
                          "Belum ada riwayat surat",
                        ),
                      ),
                    ],
                  )

                      : ListView.builder(

                    physics:
                    const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),

                    padding:
                    const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 18,
                      bottom: 120,
                    ),

                    itemCount:
                    filtered.length,

                    itemBuilder:
                        (context, index) {

                      final item =
                      filtered[index];

                      return _card(item);
                    },
                  ),
                ),
              ),
            ],
          ),

          // ================= LOADING =================
          if (isLoading)

            Container(

              color:
              Colors.black.withOpacity(
                0.15,
              ),

              child: Center(

                child: Container(

                  padding:
                  const EdgeInsets.all(
                    22,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      22,
                    ),
                  ),

                  child: const Column(

                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      SizedBox(

                        width: 34,
                        height: 34,

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color:
                          Color(
                            0xFF1565C0,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 14,
                      ),

                      Text(
                        "Mengambil riwayat surat...",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {

    final selesai =
        dataRiwayat.where(
              (e) =>

          (e['status'] ?? '')
              .toString()
              .toLowerCase() ==

              "selesai",
        ).length;

    final proses =
        dataRiwayat.where(
              (e) =>

          (e['status'] ?? '')
              .toString()
              .toLowerCase() ==

              "proses",
        ).length;

    final ditolak =
        dataRiwayat.where(
              (e) =>

          (e['status'] ?? '')
              .toString()
              .toLowerCase() ==

              "ditolak",
        ).length;

    return Container(

      height: 380,

      decoration:
      const BoxDecoration(

        image:
        DecorationImage(

          image: AssetImage(
            "assets/images/fotodesa.png",
          ),

          fit: BoxFit.cover,
        ),
      ),

      child: Container(

        decoration:
        BoxDecoration(

          gradient:
          LinearGradient(

            begin:
            Alignment.topCenter,

            end:
            Alignment.bottomCenter,

            colors: [

              Colors.black54,

              Color(
                0xFF1565C0,
              ).withOpacity(
                0.92,
              ),
            ],
          ),
        ),

        child: SafeArea(

          child: Padding(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                const SizedBox(
                  height: 6,
                ),

                const Text(
                  "Riwayat Surat",

                  style: TextStyle(
                    color:
                    Colors.white,

                    fontSize: 34,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                const Text(
                  "Pantau semua pengajuan suratmu",

                  style: TextStyle(
                    color:
                    Colors.white70,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Container(

                  height: 54,

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      28,
                    ),
                  ),

                  child: TextField(

                    textAlignVertical:
                    TextAlignVertical.center,

                    onChanged: (v) {

                      setState(() {

                        search = v;
                      });
                    },

                    decoration:
                    InputDecoration(

                      border:
                      InputBorder.none,

                      isDense: true,

                      contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      prefixIcon:
                      Icon(
                        Icons.search,
                        color:
                        Colors.grey[
                        600],
                      ),

                      suffixIcon:
                      GestureDetector(

                        onTap: () async {

                          final picked =
                          await showDatePicker(

                            context: context,

                            initialDate:
                            DateTime.now(),

                            firstDate:
                            DateTime(2020),

                            lastDate:
                            DateTime(2100),
                          );

                          if (picked != null) {

                            setState(() {

                              search = DateFormat(
                                'yyyy-MM-dd',
                              ).format(picked);

                              FocusScope.of(context).unfocus();
                            });
                          }
                        },

                        child: Container(

                          margin:
                          const EdgeInsets.all(
                            10,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.grey[
                            100],

                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),

                          child: const Icon(
                            Icons.calendar_month,
                            size: 18,
                          ),
                        ),
                      ),

                      hintText:
                      "Cari surat atau tanggal...",

                      hintStyle:
                      TextStyle(
                        color:
                        Colors.grey[
                        500],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Row(
                  children: [

                    Expanded(
                      child:
                      _statCard(
                        selesai.toString(),
                        "Selesai",
                        Colors.green,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child:
                      _statCard(
                        proses.toString(),
                        "Proses",
                        Colors.orange,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child:
                      _statCard(
                        ditolak.toString(),
                        "Ditolak",
                        Colors.red,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child:
                      _statCard(
                        dataRiwayat.length.toString(),
                        "Total",
                        Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                SizedBox(

                  height: 45,

                  child: ListView(

                    scrollDirection:
                    Axis.horizontal,

                    children: [

                      _filterChip(
                        "all",
                        "Semua",
                      ),

                      _filterChip(
                        "Surat Keterangan Tidak Mampu",
                        "SKTM",
                      ),

                      _filterChip(
                        "Surat Domisili",
                        "Domisili",
                      ),

                      _filterChip(
                        "Pengantar KTP",
                        "KTP",
                      ),

                      _filterChip(
                        "Surat Kelahiran",
                        "Kelahiran",
                      ),

                      _filterChip(
                        "Surat Penghasilan",
                        "Penghasilan",
                      ),

                      _filterChip(
                        "Surat Kematian",
                        "Kematian",
                      ),

                      _filterChip(
                        "Surat Izin",
                        "Izin",
                      ),

                      _filterChip(
                        "Surat Nikah",
                        "Nikah",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(
      String total,
      String title,
      Color color,
      ) {

    return Container(

      height: 82,

      decoration:
      BoxDecoration(

        color:
        Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Text(
            total,

            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            title,

            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.w600,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }

  Widget _filterChip(
      String value,
      String label,
      ) {

    final active =
        selectedJenis ==
            value;

    return Padding(

      padding:
      const EdgeInsets.only(
        right: 10,
      ),

      child: GestureDetector(

        onTap: () {

          setState(() {

            selectedJenis =
                value;
          });
        },

        child: AnimatedContainer(

          duration:
          const Duration(
            milliseconds: 250,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          decoration:
          BoxDecoration(

            color:

            active

                ? const Color(
              0xFF1565C0,
            )

                : Colors.white,

            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          child: Center(
            child: Text(
              label,

              style: TextStyle(

                color:

                active

                    ? Colors.white

                    : const Color(
                  0xFF1565C0,
                ),

                fontWeight:
                FontWeight.w600,

                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(
      Map<String, dynamic> item,
      ) {

    final Color color =
    item['warna'];

    final status =
    (item['status'] ?? '')
        .toString()
        .toLowerCase();

    final statusColor =

    status == "selesai"

        ? Colors.green

        : status == "ditolak"

        ? Colors.red

        : Colors.orange;

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                DetailRiwayatScreen(

                  item: {

                    ...item,

                    "jenis_api":

                    item['jenis'] ==
                        "Surat Domisili"

                        ? "domisili"

                        : item['jenis'] ==
                        "Surat Keterangan Tidak Mampu"

                        ? "sktm"

                        : item['jenis'] ==
                        "Pengantar KTP"

                        ? "ktp"

                        : item['jenis'] ==
                        "Surat Kelahiran"

                        ? "kelahiran"

                        : item['jenis'] ==
                        "Surat Penghasilan"

                        ? "penghasilan"

                        : item['jenis'] ==
                        "Surat Kematian"

                        ? "kematian"

                        : item['jenis'] ==
                        "Surat Izin"

                        ? "izin"

                        : "nikah",
                  },
                ),
          ),
        );
      },

      child: Container(

        margin:
        const EdgeInsets.only(
          bottom: 18,
        ),

        padding:
        const EdgeInsets.all(
          16,
        ),

        decoration:
        BoxDecoration(

          color:
          Colors.white,

          borderRadius:
          BorderRadius.circular(
            24,
          ),
        ),

        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Container(

              width: 68,
              height: 68,

              decoration:
              BoxDecoration(

                color:
                color.withOpacity(
                  0.12,
                ),

                borderRadius:
                BorderRadius.circular(
                  18,
                ),
              ),

              child: Icon(
                item['icon'],
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    item['jenis'],

                    maxLines: 2,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(

                    DateFormat(
                      'dd MMM yyyy',
                      'id_ID',
                    ).format(
                      DateTime.parse(
                        (
                            item['tanggal'] ??
                                DateTime.now().toString()
                        ).toString(),
                      ),
                    ),

                    style:
                    TextStyle(
                      color:
                      Colors.grey[
                      600],

                      fontSize:
                      11,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal:
                      10,
                      vertical:
                      6,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      statusColor
                          .withOpacity(
                        0.1,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),

                    child: Text(

                      (
                          item['status'] ?? 'proses'
                      )
                          .toString()
                          .toUpperCase(),

                      style:
                      TextStyle(
                        color:
                        statusColor,

                        fontWeight:
                        FontWeight.bold,

                        fontSize:
                        10,
                      ),
                    ),
                  ),

                  if (item['status'] ==
                      "ditolak")

                    Padding(

                      padding:
                      const EdgeInsets.only(
                        top: 6,
                      ),

                      child: Text(
                        item['alasan'] ??
                            "",

                        style: TextStyle(
                          color:
                          Colors.red[
                          400],

                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Column(
              children: [

                Container(

                  width: 42,
                  height: 42,

                  decoration:
                  BoxDecoration(

                    color:
                    color.withOpacity(
                      0.12,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Icon(
                    Icons.description,
                    color: color,
                    size: 20,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Icon(
                  Icons.chevron_right,
                  color:
                  Colors.grey[
                  400],
                )
              ],
            )
          ],
        ),
      ),
    );
  }}