import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/api_service.dart';

class PenghasilanScreen extends StatefulWidget {

  final int userId;

  const PenghasilanScreen({
    super.key,
    required this.userId,
  });

  @override
  State<PenghasilanScreen> createState() =>
      _PenghasilanScreenState();
}

class _PenghasilanScreenState
    extends State<PenghasilanScreen> {

  final namaC =
  TextEditingController();

  final nikC =
  TextEditingController();

  final hpC =
  TextEditingController();

  final alamatC =
  TextEditingController();

  final pekerjaanC =
  TextEditingController();

  final penghasilanC =
  TextEditingController();

  final tanggunganC =
  TextEditingController();

  final tujuanC =
  TextEditingController();

  File? fileKtp;

  bool isLoading = false;

  String metodePengambilan =
      'ambil_desa';

  // ================= PICK IMAGE =================
  Future<void> pickImage(
      ImageSource source,
      ) async {

    final picked =
    await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
    );

    if (picked != null) {

      setState(() {

        fileKtp =
            File(picked.path);
      });
    }
  }

  // ================= PILIH FOTO =================
  void pilihFoto() {

    showModalBottomSheet(
      context: context,

      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),

      builder: (_) {

        return SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.all(20),

            child: Column(
              mainAxisSize:
              MainAxisSize.min,

              children: [

                Container(
                  width: 50,
                  height: 5,

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.grey[300],

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                const Text(
                  "Pilih Kartu Keluarga",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                Row(
                  children: [

                    Expanded(
                      child: GestureDetector(
                        onTap: () async {

                          Navigator.pop(
                              context);

                          await pickImage(
                            ImageSource.camera,
                          );
                        },

                        child: Container(
                          padding:
                          const EdgeInsets.all(
                            20,
                          ),

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFFEAF2FF,
                            ),

                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: const Column(
                            children: [

                              Icon(
                                Icons.camera_alt,

                                size: 40,

                                color:
                                Color(
                                  0xFF2E6BE6,
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Text(
                                "Kamera",

                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () async {

                          Navigator.pop(
                              context);

                          await pickImage(
                            ImageSource.gallery,
                          );
                        },

                        child: Container(
                          padding:
                          const EdgeInsets.all(
                            20,
                          ),

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFFEAF2FF,
                            ),

                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: const Column(
                            children: [

                              Icon(
                                Icons.photo,

                                size: 40,

                                color:
                                Color(
                                  0xFF2E6BE6,
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Text(
                                "Galeri",

                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= VALIDASI =================
  bool validateInput() {

    if (namaC.text.trim().isEmpty ||
        nikC.text.trim().isEmpty ||
        hpC.text.trim().isEmpty ||
        alamatC.text.trim().isEmpty ||
        pekerjaanC.text.trim().isEmpty ||
        penghasilanC.text.trim().isEmpty ||
        tanggunganC.text.trim().isEmpty ||
        tujuanC.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Semua field wajib diisi",
          ),
        ),
      );

      return false;
    }

    // VALIDASI NIK
    if (!RegExp(r'^[0-9]{16}$')
        .hasMatch(
      nikC.text.trim(),
    )) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "NIK harus 16 digit angka",
          ),
        ),
      );

      return false;
    }

    // VALIDASI HP
    if (!RegExp(r'^[0-9]{10,13}$')
        .hasMatch(
      hpC.text.trim(),
    )) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Nomor HP tidak valid",
          ),
        ),
      );

      return false;
    }

    if (fileKtp == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Upload dokumen terlebih dahulu",
          ),
        ),
      );

      return false;
    }
// VALIDASI JUMLAH TANGGUNGAN
    if (int.tryParse(
      tanggunganC.text.trim(),
    ) == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Jumlah tanggungan harus angka",
          ),
        ),
      );

      return false;
    }
    return true;
  }

  // ================= SUBMIT =================
  Future<void> submit() async {

    if (!validateInput()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response =
      await ApiService.submitPenghasilan(

        userId: widget.userId.toString(),

        namaLengkap:
        namaC.text.trim(),

        nik:
        nikC.text.trim(),

        noHp:
        hpC.text.trim(),

        alamat:
        alamatC.text.trim(),

        tanggalPengajuan:
        DateTime.now()
            .toString()
            .substring(0, 10),

        pekerjaan:
        pekerjaanC.text.trim(),

        jumlahPenghasilan:
        penghasilanC.text.trim(),

        jumlahTanggungan:
        tanggunganC.text.trim(),

        tujuanPengajuan:
        tujuanC.text.trim(),

        metodePengambilan:
        metodePengambilan,

        filePath:
        fileKtp!.path,
      );

      setState(() {
        isLoading = false;
      });

      if (response['success'] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Pengajuan berhasil dikirim",
            ),

            backgroundColor:
            Colors.green,
          ),
        );

        Navigator.pop(context);

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              response['message']
                  .toString(),
            ),

            backgroundColor:
            Colors.red,
          ),
        );
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // ================= INPUT =================
  // ================= INPUT =================
  Widget field(
      String title,
      TextEditingController c, {
        bool isNumber = false,
      }) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style:
            const TextStyle(
              fontWeight:
              FontWeight.w700,

              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          TextField(
            controller: c,

            keyboardType:
            isNumber
                ? TextInputType.number
                : TextInputType.text,

            decoration:
            InputDecoration(
              filled: true,

              fillColor:
              Colors.white,

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  16,
                ),

                borderSide:
                BorderSide.none,
              ),

              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  16,
                ),

                borderSide:
                BorderSide(
                  color:
                  Colors.grey
                      .shade200,
                ),
              ),

              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  16,
                ),

                borderSide:
                const BorderSide(
                  color:
                  Color(
                    0xFF2E6BE6,
                  ),

                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
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
              30,
            ),

            decoration:
            const BoxDecoration(
              gradient:
              LinearGradient(
                colors: [
                  Color(0xFF2E6BE6),
                  Color(0xFF4D8DFF),
                ],
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

            child: Row(
              children: [

                GestureDetector(
                  onTap: () {

                    Navigator.pop(
                        context);
                  },

                  child: Container(
                    width: 42,
                    height: 42,

                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white
                          .withOpacity(
                        0.2,
                      ),

                      shape:
                      BoxShape.circle,
                    ),

                    child:
                    const Icon(
                      Icons.arrow_back,

                      color:
                      Colors.white,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Text(
                        "Surat Keterangan",

                        style:
                        TextStyle(
                          color:
                          Colors.white70,

                          fontSize: 13,
                        ),
                      ),

                      SizedBox(
                        height: 2,
                      ),

                      Text(
                        "Penghasilan",

                        style:
                        TextStyle(
                          color:
                          Colors.white,

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 22,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // ================= FORM =================
          Expanded(
            child:
            SingleChildScrollView(
              padding:
              const EdgeInsets.all(
                20,
              ),

              child: Column(
                children: [

                  field(
                    "Nama Lengkap",
                    namaC,
                  ),

                  field(
                    "NIK",
                    nikC,
                  ),

                  field(
                    "No HP",
                    hpC,
                  ),

                  field(
                    "Alamat Lengkap",
                    alamatC,
                  ),

                  field(
                    "Pekerjaan",
                    pekerjaanC,
                  ),

                  field(
                    "Jumlah Penghasilan",
                    penghasilanC,
                  ),

                  field(
                    "Jumlah Tanggungan",
                    tanggunganC,
                    isNumber: true,

                  ),

                  field(
                    "Tujuan Pengajuan",
                    tujuanC,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Align(
                    alignment:
                    Alignment
                        .centerLeft,

                    child: Text(
                      "Metode Pengambilan",

                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight
                            .w700,

                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),

                      border:
                      Border.all(
                        color:
                        Colors.grey
                            .shade300,
                      ),
                    ),

                    child:
                    DropdownButtonHideUnderline(
                      child:
                      DropdownButton<
                          String>(

                        value:
                        metodePengambilan,

                        isExpanded:
                        true,

                        items: const [

                          DropdownMenuItem(
                            value:
                            'ambil_desa',

                            child:
                            Text(
                              'Ambil di Kantor Desa',
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                            'cetak_online',

                            child:
                            Text(
                              'Cetak Online',
                            ),
                          ),
                        ],

                        onChanged:
                            (value) {

                          setState(() {

                            metodePengambilan =
                            value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // ================= UPLOAD =================
                  Align(
                    alignment:
                    Alignment
                        .centerLeft,

                    child: Text(
                      "Upload Dokumen",

                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight
                            .w700,

                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                    onTap:
                    pilihFoto,

                    child: Container(
                      width:
                      double.infinity,

                      height: 220,

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                        border:
                        Border.all(
                          color:
                          const Color(
                            0xFF2E6BE6,
                          ).withOpacity(
                            0.2,
                          ),
                        ),
                      ),

                      child:
                      fileKtp == null

                          ? Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [

                          Container(
                            width: 65,
                            height: 65,

                            decoration:
                            const BoxDecoration(
                              color:
                              Color(
                                0xFFEAF2FF,
                              ),

                              shape:
                              BoxShape.circle,
                            ),

                            child:
                            const Icon(
                              Icons
                                  .cloud_upload_rounded,

                              color:
                              Color(
                                0xFF2E6BE6,
                              ),

                              size:
                              34,
                            ),
                          ),

                          const SizedBox(
                            height:
                            14,
                          ),

                          const Text(
                            "Upload KK",

                            style:
                            TextStyle(
                              fontWeight:
                              FontWeight.bold,

                              fontSize:
                              15,
                            ),
                          ),

                          const SizedBox(
                            height:
                            4,
                          ),

                          Text(
                            "Tap untuk pilih kamera atau galeri",

                            style:
                            TextStyle(
                              color:
                              Colors.grey[
                              600],

                              fontSize:
                              12,
                            ),
                          )
                        ],
                      )

                          : ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                        child:
                        Image.file(
                          fileKtp!,

                          fit:
                          BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ================= BUTTON =================
                  SizedBox(
                    width:
                    double.infinity,

                    height: 55,

                    child:
                    ElevatedButton(

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(
                          0xFF2E6BE6,
                        ),

                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      onPressed:
                      isLoading
                          ? null
                          : submit,

                      child:
                      isLoading

                          ? const CircularProgressIndicator(
                        color:
                        Colors.white,
                      )

                          : const Text(
                        "KIRIM PENGAJUAN",

                        style:
                        TextStyle(
                          color:
                          Colors.white,

                          fontWeight:
                          FontWeight.bold,

                          fontSize:
                          15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
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