import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';

import 'tambah_saran_screen.dart';
import 'detail_saran_screen.dart';
import 'edit_saran_screen.dart';

class SaranScreen extends StatefulWidget {
  const SaranScreen({super.key});

  @override
  State<SaranScreen> createState() =>
      _SaranScreenState();
}

class _SaranScreenState
    extends State<SaranScreen> {

  bool isLoading = true;

  List saranList = [];

  @override
  void initState() {
    super.initState();
    loadSaran();
  }

  // ================= LOAD SARAN =================
  Future<void> loadSaran() async {

    setState(() {
      isLoading = true;
    });

    final user =
    await SessionService.getUser();

    final result =
    await ApiService.getSaran(
      user['email'],
    );

    if (result['success'] == true) {

      saranList = result['data'];

    } else {

      saranList = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  // ================= DELETE =================
  Future<void> deleteSaran(
      int id,
      ) async {

    final result =
    await ApiService.deleteSaran(id);

    if (result['success'] == true) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(result['message']),
          backgroundColor:
          Colors.green,
        ),
      );

      loadSaran();

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

  // ================= DIALOG =================
  void confirmDelete(int id) {

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),

          title: const Text(
            "Hapus Saran",
            style: TextStyle(
              fontWeight:
              FontWeight.w700,
            ),
          ),

          content: const Text(
            "Yakin ingin menghapus saran ini?",
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
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
              ),

              onPressed: () async {

                Navigator.pop(context);

                await deleteSaran(id);
              },

              child: const Text(
                "Hapus",
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F6FA),

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
              30,
            ),

            decoration:
            const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2E6BE6),
                  Color(0xFF4B88FF),
                ],

                begin:
                Alignment.topLeft,

                end: Alignment
                    .bottomRight,
              ),

              borderRadius:
              BorderRadius.only(
                bottomLeft:
                Radius.circular(28),

                bottomRight:
                Radius.circular(28),
              ),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                const Text(
                  "Kotak Saran",

                  style: TextStyle(
                    color:
                    Colors.white,

                    fontSize: 28,

                    fontWeight:
                    FontWeight
                        .w900,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "Kelola dan lihat seluruh saran Anda",

                  style: TextStyle(
                    color:
                    Colors.white70,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ================= TOTAL =================
                Container(
                  padding:
                  const EdgeInsets.all(
                    18,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.15,
                    ),

                    borderRadius:
                    BorderRadius
                        .circular(
                      18,
                    ),
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 55,
                        height: 55,

                        decoration:
                        BoxDecoration(
                          color: Colors
                              .white
                              .withOpacity(
                            0.2,
                          ),

                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                        ),

                        child: const Icon(
                          Icons
                              .mark_email_read_rounded,

                          color:
                          Colors.white,

                          size: 28,
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(
                            "${saranList.length}",

                            style:
                            const TextStyle(
                              color:
                              Colors
                                  .white,

                              fontWeight:
                              FontWeight
                                  .w900,

                              fontSize:
                              24,
                            ),
                          ),

                          const Text(
                            "Total Saran Yang Anda Kirim",

                            style:
                            TextStyle(
                              color: Colors
                                  .white70,

                              fontSize:
                              12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: isLoading

                ? const Center(
              child:
              CircularProgressIndicator(),
            )

                : saranList.isEmpty

                ? const Center(
              child: Text(
                "Belum ada saran",
                style: TextStyle(
                  fontWeight:
                  FontWeight
                      .w700,
                ),
              ),
            )

                : RefreshIndicator(
              onRefresh:
              loadSaran,

              child:
              ListView.builder(
                padding:
                const EdgeInsets
                    .fromLTRB(
                  16,
                  18,
                  16,
                  100,
                ),

                itemCount:
                saranList.length,

                itemBuilder:
                    (
                    context,
                    index,
                    ) {

                  final item =
                  saranList[index];

                  return GestureDetector(

                    onTap:
                        () async {

                      await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder:
                              (_) =>
                              DetailSaranScreen(
                                id: item[
                                'id'],
                              ),
                        ),
                      );

                      loadSaran();
                    },

                    child:
                    Container(
                      margin:
                      const EdgeInsets
                          .only(
                        bottom:
                        18,
                      ),

                      decoration:
                      BoxDecoration(
                        color: Colors
                            .white,

                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.06,
                            ),

                            blurRadius:
                            12,

                            offset:
                            const Offset(
                              0,
                              5,
                            ),
                          )
                        ],
                      ),

                      child:
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          // ================= FOTO =================
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(
                              top:
                              Radius.circular(
                                22,
                              ),
                            ),

                            child:
                            SizedBox(
                              height:
                              180,

                              width: double
                                  .infinity,

                              child:
                              item['foto_url'] !=
                                  null

                                  ? Image.network(
                                item['foto_url'],

                                fit: BoxFit
                                    .cover,

                                loadingBuilder:
                                    (
                                    context,
                                    child,
                                    loadingProgress,
                                    ) {

                                  if (loadingProgress ==
                                      null) {

                                    return AnimatedOpacity(
                                      opacity:
                                      1,

                                      duration:
                                      const Duration(
                                        milliseconds:
                                        400,
                                      ),

                                      child:
                                      child,
                                    );
                                  }

                                  return Container(
                                    color: const Color(
                                      0xFFF1F5FF,
                                    ),

                                    child:
                                    Center(
                                      child:
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,

                                        children: [

                                          SizedBox(
                                            width:
                                            28,

                                            height:
                                            28,

                                            child:
                                            CircularProgressIndicator(
                                              strokeWidth:
                                              3,

                                              color:
                                              const Color(
                                                0xFF2E6BE6,
                                              ),

                                              value:
                                              loadingProgress.expectedTotalBytes !=
                                                  null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),

                                          const SizedBox(
                                            height:
                                            12,
                                          ),

                                          const Text(
                                            "Memuat gambar...",

                                            style:
                                            TextStyle(
                                              color:
                                              Color(
                                                0xFF2E6BE6,
                                              ),

                                              fontWeight:
                                              FontWeight.w600,

                                              fontSize:
                                              12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },

                                errorBuilder:
                                    (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {

                                  return Container(
                                    color: Colors
                                        .grey
                                        .shade200,

                                    child:
                                    const Center(
                                      child:
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,

                                        children: [

                                          Icon(
                                            Icons.broken_image_rounded,

                                            color:
                                            Colors.grey,

                                            size:
                                            42,
                                          ),

                                          SizedBox(
                                            height:
                                            10,
                                          ),

                                          Text(
                                            "Gambar gagal dimuat",

                                            style:
                                            TextStyle(
                                              color:
                                              Colors.grey,

                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )

                                  : Container(
                                height: 180,
                                width: double.infinity,

                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFEDF4FF),
                                      const Color(0xFFDCE9FF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),

                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Container(
                                        width: 72,
                                        height: 72,

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(22),

                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.12),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            )
                                          ],
                                        ),

                                        child: const Icon(
                                          Icons.photo_library_rounded,
                                          size: 38,
                                          color: Color(0xFF2E6BE6),
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      const Text(
                                        "Tidak ada foto",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF2E6BE6),
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      const Text(
                                        "Pengguna tidak menambahkan gambar",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7A99),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets
                                .all(
                              16,
                            ),

                            child:
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                // ================= TITLE =================
                                Row(
                                  children: [

                                    Expanded(
                                      child:
                                      Text(
                                        item['judul'] ??
                                            '',

                                        style:
                                        const TextStyle(
                                          fontWeight:
                                          FontWeight.w800,

                                          fontSize:
                                          17,

                                          color:
                                          Color(
                                            0xFF222222,
                                          ),
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap:
                                          () async {

                                        await Navigator.push(
                                          context,

                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                EditSaranScreen(
                                                  saran:
                                                  item,
                                                ),
                                          ),
                                        );

                                        loadSaran();
                                      },

                                      child:
                                      Container(
                                        padding:
                                        const EdgeInsets.all(
                                          8,
                                        ),

                                        decoration:
                                        BoxDecoration(
                                          color:
                                          const Color(
                                            0xFFEDF3FF,
                                          ),

                                          borderRadius:
                                          BorderRadius.circular(
                                            10,
                                          ),
                                        ),

                                        child:
                                        const Icon(
                                          Icons
                                              .edit,

                                          color:
                                          Color(
                                            0xFF2E6BE6,
                                          ),

                                          size:
                                          20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height:
                                  10,
                                ),

                                // ================= ISI =================
                                Text(
                                  item['isi_saran'] ??
                                      '',

                                  maxLines:
                                  2,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  const TextStyle(
                                    fontSize:
                                    13,

                                    color:
                                    Color(
                                      0xFF666666,
                                    ),

                                    height:
                                    1.6,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                  14,
                                ),

                                // ================= FOOTER =================
                                Row(
                                  children: [

                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal:
                                        10,

                                        vertical:
                                        7,
                                      ),

                                      decoration:
                                      BoxDecoration(
                                        color:
                                        const Color(
                                          0xFFEAF2FF,
                                        ),

                                        borderRadius:
                                        BorderRadius.circular(
                                          30,
                                        ),
                                      ),

                                      child:
                                      Row(
                                        children: [

                                          const Icon(
                                            Icons.calendar_month,

                                            size:
                                            14,

                                            color:
                                            Color(
                                              0xFF2E6BE6,
                                            ),
                                          ),

                                          const SizedBox(
                                            width:
                                            6,
                                          ),

                                          Text(
                                            item['tanggal_dikirim']
                                                .toString(),

                                            style:
                                            const TextStyle(
                                              fontSize:
                                              11,

                                              fontWeight:
                                              FontWeight.w700,

                                              color:
                                              Color(
                                                0xFF2E6BE6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Spacer(),

                                    GestureDetector(
                                      onTap:
                                          () {

                                        confirmDelete(
                                          item[
                                          'id'],
                                        );
                                      },

                                      child:
                                      Container(
                                        padding:
                                        const EdgeInsets.all(
                                          10,
                                        ),

                                        decoration:
                                        BoxDecoration(
                                          color: Colors
                                              .red
                                              .shade50,

                                          borderRadius:
                                          BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        child:
                                        const Icon(
                                          Icons
                                              .delete_outline,

                                          color:
                                          Colors
                                              .red,

                                          size:
                                          22,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
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

      // ================= BUTTON TAMBAH =================
      floatingActionButton:
      Container(
        margin:
        const EdgeInsets.only(
          bottom: 8,
        ),

        child: GestureDetector(
          onTap: () async {

            final result =
            await Navigator.push(
              context,

              MaterialPageRoute(
                builder:
                    (_) =>
                const TambahSaranScreen(),
              ),
            );

            if (result == true) {
              loadSaran();
            }
          },

          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 15,
            ),

            decoration:
            BoxDecoration(
              gradient:
              const LinearGradient(
                colors: [
                  Color(
                    0xFF2E6BE6,
                  ),
                  Color(
                    0xFF4B88FF,
                  ),
                ],

                begin:
                Alignment.topLeft,

                end: Alignment
                    .bottomRight,
              ),

              borderRadius:
              BorderRadius.circular(
                18,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                  const Color(
                    0xFF2E6BE6,
                  ).withOpacity(
                    0.35,
                  ),

                  blurRadius:
                  18,

                  offset:
                  const Offset(
                    0,
                    8,
                  ),
                )
              ],
            ),

            child: const Row(
              mainAxisSize:
              MainAxisSize.min,

              children: [

                Icon(
                  Icons.add_rounded,
                  color:
                  Colors.white,

                  size: 24,
                ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  "Tambah Saran",

                  style: TextStyle(
                    color:
                    Colors.white,

                    fontWeight:
                    FontWeight
                        .w800,

                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation
          .endFloat,
    );
  }
}