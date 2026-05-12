import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import 'edit_saran_screen.dart';

class DetailSaranScreen extends StatefulWidget {

  final int id;

  const DetailSaranScreen({
    super.key,
    required this.id,
  });

  @override
  State<DetailSaranScreen> createState() =>
      _DetailSaranScreenState();
}

class _DetailSaranScreenState
    extends State<DetailSaranScreen> {

  bool isLoading = true;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  // ================= LOAD DETAIL =================
  Future<void> loadDetail() async {

    setState(() {
      isLoading = true;
    });

    final result =
    await ApiService.detailSaran(
      widget.id,
    );

    if (result['success'] == true) {

      data = result['data'];
    }

    setState(() {
      isLoading = false;
    });
  }

  // ================= DELETE =================
  Future<void> deleteSaran() async {

    final result =
    await ApiService.deleteSaran(
      widget.id,
    );

    if (result['success'] == true) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(result['message']),
          backgroundColor:
          Colors.green,
        ),
      );

      Navigator.pop(
        context,
        true,
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(result['message']),
          backgroundColor:
          Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    if (data == null) {

      return const Scaffold(
        body: Center(
          child:
          Text("Data tidak ditemukan"),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F6FA),

      body: CustomScrollView(
        slivers: [

          // ================= APPBAR =================
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,

            backgroundColor:
            Colors.white,

            elevation: 0,

            automaticallyImplyLeading: false,

            leading: Padding(
              padding:
              const EdgeInsets.all(10),

              child: Container(
                decoration: BoxDecoration(
                  color:
                  Colors.white
                      .withOpacity(0.92),

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(
                        0.08,
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

                child: IconButton(
                  icon: const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,

                    size: 18,

                    color:
                    Colors.black87,
                  ),

                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
            ),

            flexibleSpace:
            FlexibleSpaceBar(

              background:
              data!['foto_url'] != null

                  ? Image.network(
                data!['foto_url'],
                fit: BoxFit.cover,

                loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                    ) {

                  if (loadingProgress ==
                      null) {
                    return child;
                  }

                  return Container(
                    color: const Color(
                      0xFFF1F5FF,
                    ),

                    child: const Center(
                      child:
                      CircularProgressIndicator(
                        color: Color(
                          0xFF2E6BE6,
                        ),
                      ),
                    ),
                  );
                },

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {

                  return Container(
                    color:
                    Colors.grey.shade300,

                    child: const Center(
                      child: Icon(
                        Icons
                            .broken_image,
                        size: 60,
                        color:
                        Colors.grey,
                      ),
                    ),
                  );
                },
              )

                  : Container(
                height: 180,
                width: double.infinity,

                decoration:
                const BoxDecoration(
                  gradient:
                  LinearGradient(
                    colors: [
                      Color(
                        0xFFEDF4FF,
                      ),
                      Color(
                        0xFFDCE9FF,
                      ),
                    ],

                    begin:
                    Alignment.topLeft,

                    end: Alignment
                        .bottomRight,
                  ),
                ),

                child: Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [

                      Container(
                        width: 72,
                        height: 72,

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
                                  .blue
                                  .withOpacity(
                                0.12,
                              ),

                              blurRadius:
                              12,

                              offset:
                              const Offset(
                                0,
                                4,
                              ),
                            )
                          ],
                        ),

                        child: const Icon(
                          Icons
                              .photo_library_rounded,

                          size: 38,

                          color:
                          Color(
                            0xFF2E6BE6,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      const Text(
                        "Tidak ada foto",

                        style:
                        TextStyle(
                          fontSize: 15,

                          fontWeight:
                          FontWeight
                              .w800,

                          color:
                          Color(
                            0xFF2E6BE6,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      const Text(
                        "Pengguna tidak menambahkan gambar",

                        style:
                        TextStyle(
                          fontSize: 12,

                          color:
                          Color(
                            0xFF6B7A99,
                          ),

                          fontWeight:
                          FontWeight
                              .w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ================= CONTENT =================
          SliverToBoxAdapter(
            child: Container(
              padding:
              const EdgeInsets.all(20),

              decoration:
              const BoxDecoration(
                color:
                Color(0xFFF5F6FA),

                borderRadius:
                BorderRadius.vertical(
                  top: Radius.circular(
                    26,
                  ),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  // ================= JUDUL =================
                  Text(
                    data!['judul'] ?? '',

                    style:
                    const TextStyle(
                      fontSize: 24,

                      fontWeight:
                      FontWeight.w800,

                      color:
                      Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ================= TANGGAL =================
                  Row(
                    children: [

                      const Icon(
                        Icons
                            .calendar_month,

                        size: 18,

                        color:
                        Colors.blue,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        data![
                        'tanggal_dikirim']
                            .toString(),

                        style:
                        const TextStyle(
                          fontSize: 13,

                          fontWeight:
                          FontWeight
                              .w600,

                          color:
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ================= ISI =================
                  Text(
                    data!['isi_saran'] ??
                        '',

                    style:
                    const TextStyle(
                      fontSize: 15,

                      height: 1.8,

                      color:
                      Color(0xFF444444),
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // ================= BUTTON =================
                  Row(
                    children: [

                      // ================= EDIT =================
                      Expanded(
                        child:
                        ElevatedButton.icon(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                              0xFF2E6BE6,
                            ),

                            minimumSize:
                            const Size(
                              double.infinity,
                              50,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          onPressed:
                              () async {

                            final result =
                            await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                    EditSaranScreen(
                                      saran:
                                      data!,
                                    ),
                              ),
                            );

                            if (result ==
                                true) {

                              loadDetail();
                            }
                          },

                          icon:
                          const Icon(
                            Icons.edit,

                            color: Colors
                                .white,
                          ),

                          label:
                          const Text(
                            "EDIT SARAN",

                            style:
                            TextStyle(
                              color: Colors
                                  .white,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      // ================= DELETE =================
                      Expanded(
                        child:
                        ElevatedButton.icon(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.red,

                            minimumSize:
                            const Size(
                              double.infinity,
                              50,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          onPressed:
                              () {

                            showDialog(
                              context:
                              context,

                              builder:
                                  (_) =>
                                  AlertDialog(
                                    title:
                                    const Text(
                                      "Hapus Saran",
                                    ),

                                    content:
                                    const Text(
                                      "Yakin ingin menghapus saran ini?",
                                    ),

                                    actions: [

                                      TextButton(
                                        onPressed:
                                            () {

                                          Navigator.pop(
                                            context,
                                          );
                                        },

                                        child:
                                        const Text(
                                          "Batal",
                                        ),
                                      ),

                                      ElevatedButton(
                                        style:
                                        ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Colors.red,
                                        ),

                                        onPressed:
                                            () async {

                                          Navigator.pop(
                                            context,
                                          );

                                          await deleteSaran();
                                        },

                                        child:
                                        const Text(
                                          "Hapus",
                                        ),
                                      )
                                    ],
                                  ),
                            );
                          },

                          icon:
                          const Icon(
                            Icons.delete,

                            color:
                            Colors.white,
                          ),

                          label:
                          const Text(
                            "HAPUS",

                            style:
                            TextStyle(
                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}