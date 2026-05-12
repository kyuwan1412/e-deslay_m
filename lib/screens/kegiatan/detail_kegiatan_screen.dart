import 'package:flutter/material.dart';

import '../../../services/api_service.dart';

class DetailKegiatanScreen
    extends StatefulWidget {

  final int id;

  const DetailKegiatanScreen({
    super.key,
    required this.id,
  });

  @override
  State<DetailKegiatanScreen>
  createState() =>
      _DetailKegiatanScreenState();
}

class _DetailKegiatanScreenState
    extends State<DetailKegiatanScreen> {

  Map<String, dynamic>? data;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getDetail();
  }

  // ================= GET DETAIL =================
  Future<void> getDetail() async {

    setState(() {
      isLoading = true;
    });

    final response =
    await ApiService.detailKegiatan(
      widget.id,
    );

    if (response['success'] == true) {

      data = response['data'];
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        backgroundColor:
        Color(0xFFF4F7FB),

        body: Center(
          child:
          CircularProgressIndicator(
            color:
            Color(0xFF2E6BE6),
          ),
        ),
      );
    }

    if (data == null) {

      return const Scaffold(
        backgroundColor:
        Color(0xFFF4F7FB),

        body: Center(
          child: Text(
            "Data kegiatan tidak ditemukan",
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F7FB),

      body: CustomScrollView(
        slivers: [

          // ================= APPBAR =================
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,

            automaticallyImplyLeading:
            false,

            backgroundColor:
            const Color(0xFF2E6BE6),

            flexibleSpace:
            FlexibleSpaceBar(

              title: Text(
                data!['judul'] ?? '',

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              background: Hero(
                tag: data!['id'],

                child: Stack(
                  fit: StackFit.expand,

                  children: [

                    Image.network(
                      data!['foto_url'] ??
                          '',

                      fit: BoxFit.cover,

                      errorBuilder:
                          (
                          context,
                          error,
                          stackTrace,
                          ) {

                        return Container(
                          color:
                          const Color(
                            0xFFF1F5FF,
                          ),

                          child:
                          const Icon(
                            Icons
                                .image_not_supported,

                            color:
                            Colors.grey,

                            size: 60,
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
                              0.6,
                            ),

                            Colors
                                .transparent,
                          ],
                        ),
                      ),
                    ),

                    // ================= BUTTON KEMBALI =================
                    Positioned(
                      top: 50,
                      left: 16,

                      child: GestureDetector(

                        onTap: () {

                          Navigator.pop(
                            context,
                          );
                        },

                        child: Container(
                          width: 42,
                          height: 42,

                          decoration:
                          BoxDecoration(
                            color: Colors.white,

                            shape:
                            BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withOpacity(
                                  0.12,
                                ),

                                blurRadius:
                                8,

                                offset:
                                const Offset(
                                  0,
                                  3,
                                ),
                              )
                            ],
                          ),

                          child: const Icon(
                            Icons.arrow_back_ios_new,

                            size: 18,

                            color:
                            Color(
                              0xFF444444,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= CONTENT =================
          SliverToBoxAdapter(
            child: Container(
              padding:
              const EdgeInsets.all(
                22,
              ),

              decoration:
              const BoxDecoration(
                color:
                Color(0xFFF4F7FB),

                borderRadius:
                BorderRadius.vertical(
                  top:
                  Radius.circular(
                    28,
                  ),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    data!['judul'] ?? '',

                    style:
                    const TextStyle(
                      fontSize: 26,

                      fontWeight:
                      FontWeight.w900,

                      color:
                      Color(
                        0xFF222222,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ================= INFO =================
                  Container(
                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withOpacity(
                            0.04,
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

                    child: Column(
                      children: [

                        Row(
                          children: [

                            Container(
                              width: 42,
                              height: 42,

                              decoration:
                              BoxDecoration(
                                color:
                                const Color(
                                  0xFFEAF2FF,
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child:
                              const Icon(
                                Icons
                                    .calendar_month,

                                color:
                                Color(
                                  0xFF2E6BE6,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width:
                              14,
                            ),

                            Expanded(
                              child:
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  const Text(
                                    "Tanggal Kegiatan",

                                    style:
                                    TextStyle(
                                      fontSize:
                                      12,

                                      color:
                                      Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                    2,
                                  ),

                                  Text(
                                    data![
                                    'tanggal'] ??
                                        '-',

                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.w700,

                                      fontSize:
                                      14,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Row(
                          children: [

                            Container(
                              width: 42,
                              height: 42,

                              decoration:
                              BoxDecoration(
                                color:
                                Colors.red
                                    .shade50,

                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child:
                              const Icon(
                                Icons
                                    .location_on,

                                color:
                                Colors.red,
                              ),
                            ),

                            const SizedBox(
                              width:
                              14,
                            ),

                            Expanded(
                              child:
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  const Text(
                                    "Lokasi",

                                    style:
                                    TextStyle(
                                      fontSize:
                                      12,

                                      color:
                                      Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                    2,
                                  ),

                                  Text(
                                    data![
                                    'lokasi'] ??
                                        '-',

                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.w700,

                                      fontSize:
                                      14,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  const Text(
                    "Deskripsi Kegiatan",

                    style: TextStyle(
                      fontWeight:
                      FontWeight.w800,

                      fontSize: 18,

                      color:
                      Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Text(
                    data!['deskripsi'] ??
                        '',

                    style:
                    const TextStyle(
                      fontSize: 15,

                      color:
                      Color(0xFF555555),

                      height: 1.8,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}