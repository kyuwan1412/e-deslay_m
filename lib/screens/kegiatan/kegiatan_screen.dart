import 'package:flutter/material.dart';

import '../../../services/api_service.dart';
import 'detail_kegiatan_screen.dart';

class KegiatanScreen extends StatefulWidget {
  const KegiatanScreen({super.key});

  @override
  State<KegiatanScreen> createState() =>
      _KegiatanScreenState();
}

class _KegiatanScreenState
    extends State<KegiatanScreen> {

  final TextEditingController
  searchController =
  TextEditingController();

  List<Map<String, dynamic>>
  kegiatan = [];

  List<Map<String, dynamic>>
  filteredKegiatan = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getKegiatan();
  }

  // ================= GET DATA =================
  Future<void> getKegiatan() async {

    setState(() {
      isLoading = true;
    });

    final response =
    await ApiService.getKegiatan();

    if (response['success'] == true) {

      kegiatan =
      List<Map<String, dynamic>>.from(
        response['data'],
      );

      filteredKegiatan = kegiatan;
    }

    setState(() {
      isLoading = false;
    });
  }

  // ================= SEARCH =================
  void searchKegiatan(String value) {

    setState(() {

      filteredKegiatan =
          kegiatan.where((item) {

            final judul =
            item['judul']
                .toString()
                .toLowerCase();

            return judul.contains(
              value.toLowerCase(),
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F7FB),

      body: Column(
        children: [

          // ================= HEADER =================
          Container(
            width: double.infinity,

            padding:
            const EdgeInsets.fromLTRB(
              20,
              55,
              20,
              26,
            ),

            decoration:
            const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2E6BE6),
                  Color(0xFF4D8DFF),
                ],
                begin:
                Alignment.topLeft,
                end:
                Alignment.bottomRight,
              ),

              borderRadius:
              BorderRadius.only(
                bottomLeft:
                Radius.circular(
                  30,
                ),
                bottomRight:
                Radius.circular(
                  30,
                ),
              ),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(
                  "Kegiatan Desa",

                  style: TextStyle(
                    color:
                    Colors.white,

                    fontSize: 28,

                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Informasi kegiatan terbaru desa Banjardowo",

                  style: TextStyle(
                    color:
                    Colors.white70,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                // ================= SEARCH =================
                Container(
                  height: 52,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.06,
                        ),

                        blurRadius: 10,

                        offset:
                        const Offset(
                          0,
                          4,
                        ),
                      )
                    ],
                  ),

                  child: TextField(
                    controller:
                    searchController,

                    onChanged:
                    searchKegiatan,

                    textAlignVertical:
                    TextAlignVertical.center,

                    style:
                    const TextStyle(
                      fontSize: 14,
                    ),

                    decoration:
                    const InputDecoration(
                      border:
                      InputBorder.none,

                      prefixIcon:
                      Icon(
                        Icons.search,
                        color:
                        Color(
                          0xFF2E6BE6,
                        ),
                      ),

                      hintText:
                      "Cari kegiatan desa...",

                      hintStyle:
                      TextStyle(
                        color:
                        Colors.grey,
                        fontSize: 14,
                      ),

                      contentPadding:
                      EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= BANNER =================
          Container(
            margin:
            const EdgeInsets.all(16),

            height: 180,

            decoration:
            BoxDecoration(
              borderRadius:
              BorderRadius.circular(
                24,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.08,
                  ),

                  blurRadius: 12,

                  offset:
                  const Offset(
                    0,
                    5,
                  ),
                )
              ],
            ),

            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(
                24,
              ),

              child: Stack(
                fit: StackFit.expand,

                children: [

                  Image.asset(
                    "assets/images/bannerkegiatan.png",
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration:
                    BoxDecoration(
                      gradient:
                      LinearGradient(
                        begin: Alignment
                            .bottomCenter,

                        end: Alignment
                            .topCenter,

                        colors: [
                          Colors.black
                              .withOpacity(
                            0.55,
                          ),

                          Colors
                              .transparent,
                        ],
                      ),
                    ),
                  ),

                  const Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          "Kegiatan Warga Banjardowo",

                          style: TextStyle(
                            color:
                            Colors.white,

                            fontWeight:
                            FontWeight
                                .w800,

                            fontSize:
                            22,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Pantau seluruh aktivitas dan kegiatan terbaru desa.",

                          style: TextStyle(
                            color:
                            Colors.white70,

                            fontSize:
                            13,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // ================= LIST =================
          Expanded(
            child:

            isLoading

                ? const Center(
              child:
              CircularProgressIndicator(
                color:
                Color(0xFF2E6BE6),
              ),
            )

                : filteredKegiatan
                .isEmpty

                ? const Center(
              child: Text(
                "Kegiatan tidak ditemukan",
              ),
            )

                : RefreshIndicator(

              color:
              const Color(
                0xFF2E6BE6,
              ),

              onRefresh:
              getKegiatan,

              child:
              ListView.builder(
                padding:
                const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 100,
                ),

                itemCount:
                filteredKegiatan
                    .length,

                itemBuilder:
                    (
                    context,
                    index,
                    ) {

                  final item =
                  filteredKegiatan[
                  index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              DetailKegiatanScreen(
                                id:
                                item[
                                'id'],
                              ),
                        ),
                      );
                    },

                    child: Container(
                      margin:
                      const EdgeInsets.only(
                        bottom: 18,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.05,
                            ),

                            blurRadius:
                            10,

                            offset:
                            const Offset(
                              0,
                              4,
                            ),
                          )
                        ],
                      ),

                      child: Stack(
                        children: [

                          Row(
                            children: [

                              // ================= FOTO =================
                              Hero(
                                tag:
                                item['id'],

                                child:
                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.only(
                                    topLeft:
                                    Radius.circular(
                                      22,
                                    ),
                                    bottomLeft:
                                    Radius.circular(
                                      22,
                                    ),
                                  ),

                                  child:
                                  Image.network(
                                    item[
                                    'foto_url'] ??
                                        '',

                                    width: 120,

                                    height: 120,

                                    fit: BoxFit
                                        .cover,

                                    errorBuilder:
                                        (
                                        context,
                                        error,
                                        stackTrace,
                                        ) {

                                      return Container(
                                        width:
                                        120,

                                        height:
                                        120,

                                        color:
                                        const Color(
                                          0xFFF1F5FF,
                                        ),

                                        child:
                                        const Icon(
                                          Icons
                                              .image_not_supported,

                                          color:
                                          Colors
                                              .grey,
                                        ),
                                      );
                                    },

                                    loadingBuilder:
                                        (
                                        context,
                                        child,
                                        progress,
                                        ) {

                                      if (progress ==
                                          null) {
                                        return child;
                                      }

                                      return Container(
                                        width:
                                        120,

                                        height:
                                        120,

                                        color:
                                        const Color(
                                          0xFFF1F5FF,
                                        ),

                                        child:
                                        const Center(
                                          child:
                                          CircularProgressIndicator(
                                            color:
                                            Color(
                                              0xFF2E6BE6,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(
                                    14,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

                                      // ================= BADGE TERBARU =================
                                      if (index < 2)
                                        Container(
                                          margin:
                                          const EdgeInsets.only(
                                            bottom:
                                            8,
                                          ),

                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal:
                                            10,

                                            vertical:
                                            5,
                                          ),

                                          decoration:
                                          BoxDecoration(
                                            gradient:
                                            const LinearGradient(
                                              colors: [
                                                Color(
                                                  0xFFFF8A00,
                                                ),
                                                Color(
                                                  0xFFFFB347,
                                                ),
                                              ],
                                            ),

                                            borderRadius:
                                            BorderRadius.circular(
                                              30,
                                            ),
                                          ),

                                          child:
                                          const Row(
                                            mainAxisSize:
                                            MainAxisSize.min,

                                            children: [

                                              Icon(
                                                Icons
                                                    .local_fire_department,

                                                color:
                                                Colors.white,

                                                size:
                                                14,
                                              ),

                                              SizedBox(
                                                width:
                                                4,
                                              ),

                                              Text(
                                                "TERBARU",

                                                style:
                                                TextStyle(
                                                  color:
                                                  Colors.white,

                                                  fontSize:
                                                  10,

                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      Text(
                                        item[
                                        'judul'] ??
                                            '-',

                                        maxLines: 2,

                                        overflow:
                                        TextOverflow
                                            .ellipsis,

                                        style:
                                        const TextStyle(
                                          fontSize:
                                          16,

                                          fontWeight:
                                          FontWeight
                                              .w800,

                                          color:
                                          Color(
                                            0xFF222222,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 8,
                                      ),

                                      Row(
                                        children: [

                                          const Icon(
                                            Icons
                                                .calendar_month,

                                            size: 16,

                                            color:
                                            Color(
                                              0xFF2E6BE6,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 6,
                                          ),

                                          Expanded(
                                            child:
                                            Text(
                                              item[
                                              'tanggal'] ??
                                                  '-',

                                              style:
                                              const TextStyle(
                                                fontSize:
                                                12,

                                                color:
                                                Colors.grey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 8,
                                      ),

                                      Row(
                                        children: [

                                          const Icon(
                                            Icons
                                                .location_on,

                                            size: 16,

                                            color:
                                            Colors.red,
                                          ),

                                          const SizedBox(
                                            width: 6,
                                          ),

                                          Expanded(
                                            child:
                                            Text(
                                              item[
                                              'lokasi'] ??
                                                  '-',

                                              maxLines:
                                              1,

                                              overflow:
                                              TextOverflow
                                                  .ellipsis,

                                              style:
                                              const TextStyle(
                                                fontSize:
                                                12,

                                                color:
                                                Colors.grey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}