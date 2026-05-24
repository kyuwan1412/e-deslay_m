import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../services/api_service.dart';

class IzinScreen extends StatefulWidget {

  final int userId;

  const IzinScreen({
    super.key,
    required this.userId,
  });

  @override
  State<IzinScreen> createState() =>
      _IzinScreenState();
}

class _IzinScreenState
    extends State<IzinScreen> {

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('id');
  }

  final namaC =
  TextEditingController();

  final nikC =
  TextEditingController();

  final hpC =
  TextEditingController();

  final alamatC =
  TextEditingController();

  final namaKegiatanC =
  TextEditingController();

  final lokasiKegiatanC =
  TextEditingController();

  final tanggalKegiatanC =
  TextEditingController();

  final waktuKegiatanC =
  TextEditingController();

  final penanggungJawabC =
  TextEditingController();

  File? fileDokumen;

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

        fileDokumen =
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

                const SizedBox(height: 25),

                const Text(
                  "Upload KTP Anda",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

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

                              SizedBox(height: 10),

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

                    const SizedBox(width: 14),

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

                              SizedBox(height: 10),

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

  // ================= SUBMIT =================
  Future<void> submit() async {

    if (namaC.text.isEmpty ||
        nikC.text.isEmpty ||
        hpC.text.isEmpty ||
        alamatC.text.isEmpty ||
        namaKegiatanC.text.isEmpty ||
        lokasiKegiatanC.text.isEmpty ||
        tanggalKegiatanC.text.isEmpty ||
        waktuKegiatanC.text.isEmpty ||
        penanggungJawabC.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Semua field wajib diisi",
          ),
        ),
      );

      return;
    }

    if (fileDokumen == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Upload dokumen terlebih dahulu",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response =
      await ApiService.submitIzin(

        userId:
        widget.userId.toString(),

        namaLengkap:
        namaC.text,

        nik:
        nikC.text,

        noHp:
        hpC.text,

        alamat:
        alamatC.text,

        tanggalPengajuan:
        DateTime.now()
            .toString()
            .substring(0, 10),

        namaKegiatan:
        namaKegiatanC.text,

        lokasiKegiatan:
        lokasiKegiatanC.text,

        tanggalKegiatan:
        DateFormat(
          'yyyy-MM-dd',
        ).format(

          DateFormat(
            'dd MMMM yyyy',
            'id',
          ).parse(
            tanggalKegiatanC.text,
          ),
        ),

        waktuKegiatan:
        waktuKegiatanC.text,

        penanggungJawab:
        penanggungJawabC.text,

        metodePengambilan:
        metodePengambilan,

        filePath:
        fileDokumen!.path,
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
  Widget field(
      String title,
      TextEditingController c,
      ) {

    return Padding(
      padding:
      const EdgeInsets.only(
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

          const SizedBox(height: 8),

          TextField(
            controller: c,

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
                  Colors.grey.shade200,
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
                        "Izin",

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
                    "Alamat",
                    alamatC,
                  ),

                  field(
                    "Nama Kegiatan",
                    namaKegiatanC,
                  ),

                  field(
                    "Lokasi Kegiatan",
                    lokasiKegiatanC,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 18,
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Tanggal Kegiatan",

                          style: TextStyle(
                            fontWeight:
                            FontWeight.w700,

                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller:
                          tanggalKegiatanC,

                          readOnly: true,

                          onTap: () async {

                            DateTime? pickedDate =
                            await showDatePicker(

                              context: context,

                              locale: const Locale('id'),

                              initialDate:
                              DateTime.now(),

                              firstDate:
                              DateTime(2000),

                              lastDate:
                              DateTime(2100),
                            );

                            if (pickedDate != null) {

                              String tanggal =
                              DateFormat(
                                'dd MMMM yyyy',
                                'id',
                              ).format(
                                pickedDate,
                              );

                              setState(() {

                                tanggalKegiatanC
                                    .text = tanggal;
                              });
                            }
                          },

                          decoration:
                          InputDecoration(

                            hintText:
                            "Pilih tanggal kegiatan",

                            suffixIcon:
                            const Icon(
                              Icons.calendar_month,

                              color:
                              Color(
                                0xFF2E6BE6,
                              ),
                            ),

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
                          ),
                        )
                      ],
                    ),
                  ),

                  field(
                    "Waktu Kegiatan",
                    waktuKegiatanC,
                  ),

                  field(
                    "Penanggung Jawab",
                    penanggungJawabC,
                  ),

                  Align(
                    alignment:
                    Alignment.centerLeft,

                    child: Text(
                      "Metode Pengambilan",

                      style: TextStyle(
                        fontWeight:
                        FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),

                      border: Border.all(
                        color:
                        Colors.grey.shade300,
                      ),
                    ),

                    child:
                    DropdownButtonHideUnderline(
                      child:
                      DropdownButton<String>(

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

                  const SizedBox(height: 18),

                  Align(
                    alignment:
                    Alignment.centerLeft,

                    child: Text(
                      "Upload Dokumen",

                      style: TextStyle(
                        fontWeight:
                        FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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
                      fileDokumen == null

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
                            "Upload KTP Anda",

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
                          fileDokumen!,

                          fit:
                          BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}