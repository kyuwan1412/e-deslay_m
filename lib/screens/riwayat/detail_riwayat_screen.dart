import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/api_service.dart';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../surat/sktm/edit_sktm_screen.dart';
import '../surat/domisili/edit_domisili_screen.dart';
import '../surat/ktp/edit_ktp_screen.dart';
import '../surat/kelahiran/edit_kelahiran_screen.dart';
import '../surat/penghasilan/edit_penghasilan_screen.dart';
import '../surat/kematian/edit_kematian_screen.dart';
import '../surat/izin/edit_izin_screen.dart';
import '../surat/nikah/edit_nikah_screen.dart';


class DetailRiwayatScreen extends StatefulWidget {

  final Map<String, dynamic> item;

  const DetailRiwayatScreen({
    super.key,
    required this.item,
  });

  @override
  State<DetailRiwayatScreen> createState() =>
      _DetailRiwayatScreenState();
}

class _DetailRiwayatScreenState
    extends State<DetailRiwayatScreen> {

  bool isLoading = true;

  bool fileSudahDidownload = false;

  String downloadedFilePath = "";

  Map<String, dynamic> detail = {};

  @override
  void initState() {
    super.initState();

    getDetail();
  }

  // ================= GET DETAIL =================
  Future<void> getDetail() async {

    try {

      final response =
      await ApiService.getRiwayatDetail(

        widget.item['jenis_api'],
        widget.item['id'],
      );

      if (response['success']) {

        if (mounted) {

          setState(() {

            detail =
            response['data'];

            isLoading = false;
          });
        }

      } else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(

            content: Text(

              response['message'] ??
                  'Gagal mengambil detail',
            ),
          ),
        );
      }

    } catch (e) {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ================= DOWNLOAD PDF =================
  Future<void> downloadPdf() async {

    try {

      final file =
      detail['file_surat_jadi'];

      if (file == null ||
          file.toString().isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "File tidak ditemukan",
            ),
          ),
        );

        return;
      }

      String filePath =
      file.toString();

      if (
      !filePath.startsWith("surat_jadi")
      ) {

        filePath =
            filePath.replaceAll(
              "storage/app/public/",
              "",
            );
      }

      final url =
          "${ApiService.storageUrl}/$filePath";

      if (Platform.isAndroid) {

        final androidInfo =
        await DeviceInfoPlugin()
            .androidInfo;

        if (androidInfo.version.sdkInt >= 33) {

          final photos =
          await Permission.photos.request();

          final videos =
          await Permission.videos.request();

          if (
          photos.isDenied &&
              videos.isDenied
          ) {

            if (mounted) {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Izin penyimpanan ditolak",
                  ),
                ),
              );
            }

            return;
          }

        } else {

          final storage =
          await Permission.storage.request();

          if (storage.isDenied) {

            if (mounted) {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Izin penyimpanan ditolak",
                  ),
                ),
              );
            }

            return;
          }
        }
      }

      Directory? dir;

      if (Platform.isAndroid) {

        dir = await getExternalStorageDirectory();

      } else {

        dir =
        await getApplicationDocumentsDirectory();
      }

      final fileName =
          filePath.split('/').last;

      final savePath =
          "${dir!.path}/$fileName";

      showDialog(

        context: context,

        barrierDismissible: false,

        builder: (_) {

          return const Center(
            child:
            CircularProgressIndicator(),
          );
        },
      );

      await Dio().download(
        url,
        savePath,
      );

      if (mounted) {

        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();
      }

      setState(() {

        fileSudahDidownload =
            File(savePath).existsSync();

        downloadedFilePath =
            savePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          backgroundColor:
          Colors.green,

          content: Text(
            "File berhasil didownload\nTersimpan di Folder Download",
          ),
        ),
      );

      final result =
      await OpenFilex.open(
        savePath,
      );

      debugPrint(result.message);

    } catch (e) {

      if (mounted) {

        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            "Gagal download file\n$e",
          ),
        ),
      );
    }
  }

  // ================= OPEN FILE =================
  Future<void> bukaFile() async {

    if (downloadedFilePath.isNotEmpty) {

      await OpenFilex.open(
        downloadedFilePath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final status =
    (detail['status'] ?? '')
        .toString()
        .toLowerCase();

    final isSelesai =
        status == "selesai";

    final isDitolak =
        status == "ditolak";

    final isProses =
        status == "proses";

    Color statusColor =
        Colors.orange;

    if (isSelesai) {
      statusColor = Colors.green;
    }

    if (isDitolak) {
      statusColor = Colors.red;
    }

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F6FA),

      body:

      isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : Column(
        children: [

          // ================= HEADER =================
          Container(

            width: double.infinity,

            padding:
            const EdgeInsets.fromLTRB(
              20,
              55,
              20,
              28,
            ),

            decoration:
            BoxDecoration(

              gradient:
              LinearGradient(

                colors: [

                  statusColor,

                  statusColor.withOpacity(
                    0.7,
                  ),
                ],
              ),

              borderRadius:
              const BorderRadius.only(

                bottomLeft:
                Radius.circular(30),

                bottomRight:
                Radius.circular(30),
              ),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                GestureDetector(

                  onTap: () {
                    if (mounted) {

                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop();
                    }
                  },

                  child: Container(

                    width: 42,
                    height: 42,

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white.withOpacity(
                        0.2,
                      ),

                      shape:
                      BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  widget.item['jenis'],

                  style: const TextStyle(

                    color:
                    Colors.white,

                    fontSize: 28,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white.withOpacity(
                      0.2,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),

                  child: Text(

                    (status.isEmpty
                        ? "MENUNGGU"
                        : status.toUpperCase()),

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Row(
                  children: [

                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 16,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(

                      DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(

                        DateTime.parse(
                          (detail['tanggal_pengajuan'] ??
                              DateTime.now().toString())
                              .toString(),
                        ),
                      ),

                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(

            child: SingleChildScrollView(

              padding:
              const EdgeInsets.all(20),

              child: Column(
                children: [

                  // ================= STATUS =================
                  _cardModern(

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Row(
                          children: [

                            Icon(
                              Icons.track_changes,
                              color:
                              Color(
                                0xFF1565C0,
                              ),
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            Text(
                              "Status Pengajuan",

                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        Row(
                          children: [

                            _timeline(
                              "Dikirim",
                              true,
                            ),

                            Expanded(
                              child: Container(
                                height: 3,
                                color:
                                statusColor,
                              ),
                            ),

                            _timeline(
                              "Diproses",
                              isProses || isSelesai || isDitolak,
                            ),

                            Expanded(
                              child: Container(
                                height: 3,
                                color:
                                statusColor,
                              ),
                            ),

                            _timeline(

                              isSelesai
                                  ? "Selesai"
                                  : isDitolak
                                  ? "Ditolak"
                                  : "Menunggu",

                              isSelesai ||
                                  isDitolak,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ================= PESAN ADMIN =================
                  if (

                  (

                      isDitolak &&

                          detail['alasan_tolak'] != null &&

                          detail['alasan_tolak']
                              .toString()
                              .isNotEmpty

                  )

                      ||

                      (

                          isSelesai &&

                              detail['metode_pengambilan']
                                  .toString() ==
                                  "ambil_desa" &&

                              detail['keterangan_admin'] != null &&

                              detail['keterangan_admin']
                                  .toString()
                                  .isNotEmpty

                      )

                  )

                    Container(

                      width: double.infinity,

                      padding:
                      const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                      BoxDecoration(

                        color:

                        isDitolak

                            ? Colors.red.shade50

                            : Colors.green.shade50,

                        borderRadius:
                        BorderRadius.circular(
                          28,
                        ),

                        border: Border.all(

                          color:

                          isDitolak

                              ? Colors.red.shade100

                              : Colors.green.shade100,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Row(
                            children: [

                              Icon(

                                isDitolak

                                    ? Icons.info_rounded

                                    : Icons.check_circle,

                                color:

                                isDitolak

                                    ? Colors.red.shade400

                                    : Colors.green,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Text(

                                isDitolak

                                    ? "Pesan Admin"

                                    : "Informasi Pengambilan",

                                style: TextStyle(

                                  fontWeight:
                                  FontWeight.bold,

                                  fontSize: 17,

                                  color:

                                  isDitolak

                                      ? Colors.red.shade400

                                      : Colors.green,
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          Text(

                            isDitolak

                                ? (detail['alasan_tolak'] ?? '-').toString()

                                : (detail['keterangan_admin'] ?? '-').toString(),

                            style: const TextStyle(

                              height: 1.7,

                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 18,
                  ),

                 // ================= BUTTON EDIT =================
                  if (!isSelesai)

                    SizedBox(

                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton.icon(

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:

                          isDitolak

                              ? Colors.red

                              : const Color(
                            0xFF1565C0,
                          ),

                          elevation: 0,

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),

                        onPressed: () async {

                          dynamic result;

                          // ================= DOMISILI =================
                          if (widget.item['jenis'] ==
                              "Surat Domisili") {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditDomisiliScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= SKTM =================
                          else if (
                          widget.item['jenis'] ==
                              "Surat Keterangan Tidak Mampu"

                              ||

                              widget.item['jenis'] ==
                                  "SKTM"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditSKTMScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= KTP =================
                          else if (
                          widget.item['jenis'] ==
                              "Pengantar KTP"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditKtpScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= KELAHIRAN =================
                          else if (
                          widget.item['jenis'] ==
                              "Surat Kelahiran"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditKelahiranScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= PENGHASILAN =================
                          else if (
                          widget.item['jenis'] ==
                              "Surat Penghasilan"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditPenghasilanScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= KEMATIAN =================
                          else if (
                          widget.item['jenis'] ==
                              "Surat Kematian"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditKematianScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= IZIN =================
                          else if (
                          widget.item['jenis'] ==
                              "Surat Izin"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditIzinScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= NIKAH =================
                          else if (
                          widget.item['jenis'] ==
                              "Surat Nikah"
                          ) {

                            result =
                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditNikahScreen(
                                      data: detail,
                                    ),
                              ),
                            );
                          }

                          // ================= REFRESH =================
                          if (result == true) {

                            await getDetail();

                            if (mounted) {

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                const SnackBar(

                                  backgroundColor:
                                  Colors.green,

                                  content: Text(
                                    "Data berhasil diperbarui",
                                  ),
                                ),
                              );

                              if (mounted) {

                                Navigator.pop(
                                  context,
                                  true,
                                );
                              }
                            }
                          }
                        },

                        icon: Icon(

                          isDitolak

                              ? Icons.refresh_rounded

                              : Icons.edit_rounded,

                          color: Colors.white,
                        ),

                        label: Text(

                          isDitolak

                              ? "PERBARUI DATA"

                              : "EDIT PENGAJUAN",

                          style: const TextStyle(

                            color: Colors.white,

                            fontWeight:
                            FontWeight.bold,

                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                  if (!isSelesai)

                    const SizedBox(
                      height: 18,
                    ),

                  // ================= DOWNLOAD =================
                  if (isSelesai &&
                      detail[
                      'file_surat_jadi'] !=
                          null &&
                      detail[
                      'file_surat_jadi']
                          .toString()
                          .isNotEmpty)

                    Container(

                      width: double.infinity,

                      padding:
                      const EdgeInsets.all(
                        22,
                      ),

                      decoration:
                      BoxDecoration(

                        gradient:
                        const LinearGradient(

                          colors: [

                            Color(
                              0xFF4CAF50,
                            ),

                            Color(
                              0xFF66BB6A,
                            ),
                          ],
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          28,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.picture_as_pdf,
                                color:
                                Colors.white,
                                size: 30,
                              ),

                              SizedBox(
                                width: 12,
                              ),

                              Expanded(

                                child: Text(

                                  "File Surat Tersedia",

                                  style: TextStyle(

                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          const Text(

                            "Download surat lalu buka langsung dari aplikasi.",

                            style: TextStyle(
                              color:
                              Colors.white70,
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          Row(
                            children: [

                              Expanded(

                                child: SizedBox(

                                  height: 56,

                                  child:
                                  ElevatedButton.icon(

                                    style:
                                    ElevatedButton.styleFrom(

                                      backgroundColor:
                                      Colors.white,

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
                                    downloadPdf,

                                    icon: const Icon(
                                      Icons.download,
                                      color:
                                      Color(
                                        0xFF4CAF50,
                                      ),
                                    ),

                                    label: const Text(

                                      "DOWNLOAD PDF",

                                      style: TextStyle(

                                        color:
                                        Color(
                                          0xFF4CAF50,
                                        ),

                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              if (fileSudahDidownload)

                                const SizedBox(
                                  width: 12,
                                ),

                              if (fileSudahDidownload)

                                Container(

                                  width: 56,
                                  height: 56,

                                  decoration: BoxDecoration(

                                    gradient: const LinearGradient(

                                      colors: [

                                        Color(0xFF1976D2),
                                        Color(0xFF1565C0),
                                      ],
                                    ),

                                    borderRadius:
                                    BorderRadius.circular(
                                      18,
                                    ),
                                  ),

                                  child: Material(

                                    color: Colors.transparent,

                                    child: InkWell(

                                      borderRadius:
                                      BorderRadius.circular(
                                        18,
                                      ),

                                      onTap: bukaFile,

                                      child: const Center(

                                        child: Icon(

                                          Icons.folder_open_rounded,

                                          color: Colors.white,

                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ================= DATA =================
                  _cardModern(

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Row(
                          children: [

                            Icon(
                              Icons.person,
                              color:
                              Color(
                                0xFF1565C0,
                              ),
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            Text(
                              "Data Pemohon",

                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),


                        itemData(
                          "Nama Lengkap",
                          (
                              detail['nama_lengkap'] ??
                                  detail['nama_pelapor'] ??
                                  '-'
                          ).toString(),
                        ),

                        itemData(
                          "NIK",
                          (
                              detail['nik'] ??
                                  detail['nik_pelapor'] ??
                                  '-'
                          ).toString(),
                        ),

                        itemData(
                          "No HP",
                          (
                              detail['no_hp'] ??
                                  detail['no_hp_pelapor'] ??
                                  '-'
                          ).toString(),
                        ),

                        itemData(
                          "Alamat",
                          (
                              detail['alamat'] ??
                                  detail['alamat_pelapor'] ??
                                  '-'
                          ).toString(),
                        ),
                      ],
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

  // ================= CARD =================
  Widget _cardModern({
    required Widget child,
  }) {

    return Container(

      width: double.infinity,

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
          28,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 18,

            offset:
            const Offset(
              0,
              8,
            ),
          )
        ],
      ),

      child: child,
    );
  }

  // ================= ITEM =================
  Widget itemData(
      String title,
      String value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 18,
      ),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(

            width: 120,

            child: Text(

              title,

              style: TextStyle(
                color:
                Colors.grey[600],

                fontSize: 14,
              ),
            ),
          ),

          Expanded(

            child: Text(

              value,

              style: const TextStyle(

                fontWeight:
                FontWeight.w600,

                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= TIMELINE =================
  Widget _timeline(
      String title,
      bool active,
      ) {

    return Column(
      children: [

        Container(

          width: 34,
          height: 34,

          decoration:
          BoxDecoration(

            color:

            active

                ? const Color(
              0xFF1565C0,
            )

                : Colors.grey[300],

            shape:
            BoxShape.circle,
          ),

          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 18,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          title,

          style: const TextStyle(
            fontSize: 11,
            fontWeight:
            FontWeight.w600,
          ),
        )
      ],
    );
  }
}