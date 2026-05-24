import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/api_service.dart';

class EditNikahScreen extends StatefulWidget {

  final Map<String, dynamic> data;

  const EditNikahScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditNikahScreen> createState() =>
      _EditNikahScreenState();
}

class _EditNikahScreenState
    extends State<EditNikahScreen> {

  final formKey =
  GlobalKey<FormState>();

  bool isLoading = false;

  File? imageFile;

  final namaController =
  TextEditingController();

  final nikController =
  TextEditingController();

  final hpController =
  TextEditingController();

  final alamatController =
  TextEditingController();

  final suamiController =
  TextEditingController();

  final istriController =
  TextEditingController();

  final nikSuamiController =
  TextEditingController();

  final nikIstriController =
  TextEditingController();

  final alamatMasingController =
  TextEditingController();

  final tanggalController =
  TextEditingController();

  final lokasiController =
  TextEditingController();

  final pjController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    namaController.text =
        widget.data['nama_lengkap'] ?? "";

    nikController.text =
        widget.data['nik'] ?? "";

    hpController.text =
        widget.data['no_hp'] ?? "";

    alamatController.text =
        widget.data['alamat'] ?? "";

    suamiController.text =
        widget.data['nama_suami'] ?? "";

    istriController.text =
        widget.data['nama_istri'] ?? "";

    nikSuamiController.text =
        widget.data['nik_suami'] ?? "";

    nikIstriController.text =
        widget.data['nik_istri'] ?? "";

    alamatMasingController.text =
        widget.data['alamat_masing2'] ?? "";

    tanggalController.text =
        widget.data['tanggal_rencana'] ?? "";

    lokasiController.text =
        widget.data['lokasi_nikah'] ?? "";

    pjController.text =
        widget.data['nama_pj'] ?? "";
  }

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {

    final picked =
    await ImagePicker().pickImage(

      source: ImageSource.gallery,

      imageQuality: 70,
    );

    if (picked != null) {

      setState(() {

        imageFile =
            File(picked.path);
      });
    }
  }

  // ================= UPDATE =================
  Future<void> updateData() async {

    if (!formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response =
    await ApiService.updateNikah(

      widget.data['id'],

      {

        "nama_lengkap":
        namaController.text,

        "nik":
        nikController.text,

        "no_hp":
        hpController.text,

        "alamat":
        alamatController.text,

        "nama_suami":
        suamiController.text,

        "nama_istri":
        istriController.text,

        "nik_suami":
        nikSuamiController.text,

        "nik_istri":
        nikIstriController.text,

        "alamat_masing2":
        alamatMasingController.text,

        "tanggal_rencana":
        tanggalController.text,

        "lokasi_nikah":
        lokasiController.text,

        "nama_pj":
        pjController.text,

        "dokumen_scan":
        imageFile?.path,
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response['success'] == true) {

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

      Navigator.pop(
        context,
        true,
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            response['message']
                .toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F6FA),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor:
        const Color(0xFF1565C0),

        title: const Text(

          "Edit Surat Nikah",

          style: TextStyle(

            color: Colors.white,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: Form(

        key: formKey,

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(
            children: [

              GestureDetector(

                onTap: pickImage,

                child: Container(

                  width: double.infinity,
                  height: 200,

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      26,
                    ),

                    border: Border.all(
                      color:
                      Colors.grey.shade300,
                    ),
                  ),

                  child:

                  imageFile != null

                      ? ClipRRect(

                    borderRadius:
                    BorderRadius.circular(
                      26,
                    ),

                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )

                      : Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(

                        Icons.favorite,

                        size: 60,

                        color:
                        Colors.pink.shade300,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const Text(

                        "Upload Ulang Dokumen",

                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              field(
                "Nama Lengkap",
                namaController,
              ),

              field(
                "NIK",
                nikController,
              ),

              field(
                "No HP",
                hpController,
              ),

              field(
                "Alamat",
                alamatController,
                maxLines: 3,
              ),

              field(
                "Nama Suami",
                suamiController,
              ),

              field(
                "Nama Istri",
                istriController,
              ),

              field(
                "NIK Suami",
                nikSuamiController,
              ),

              field(
                "NIK Istri",
                nikIstriController,
              ),

              field(
                "Alamat Masing-masing",
                alamatMasingController,
                maxLines: 3,
              ),

              field(
                "Tanggal Rencana",
                tanggalController,
              ),

              field(
                "Lokasi Nikah",
                lokasiController,
              ),

              field(
                "Penanggung Jawab",
                pjController,
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 58,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(
                      0xFF1565C0,
                    ),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  onPressed:

                  isLoading
                      ? null
                      : updateData,

                  child:

                  isLoading

                      ? const CircularProgressIndicator(
                    color:
                    Colors.white,
                  )

                      : const Text(

                    "SIMPAN PERUBAHAN",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget field(
      String title,
      TextEditingController controller, {

        int maxLines = 1,
      }) {

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

            style: TextStyle(

              fontWeight:
              FontWeight.bold,

              color:
              Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(

            controller: controller,

            maxLines: maxLines,

            validator: (v) {

              if (v == null ||
                  v.isEmpty) {

                return "$title wajib diisi";
              }

              return null;
            },

            decoration:
            InputDecoration(

              hintText: title,

              filled: true,

              fillColor:
              Colors.white,

              contentPadding:
              const EdgeInsets.symmetric(

                horizontal: 20,
                vertical: 18,
              ),

              border:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                  18,
                ),

                borderSide:
                BorderSide.none,
              ),

              enabledBorder:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                  18,
                ),

                borderSide:
                BorderSide(
                  color:
                  Colors.grey.shade300,
                ),
              ),

              focusedBorder:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                  18,
                ),

                borderSide:
                const BorderSide(
                  color:
                  Color(0xFF1565C0),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}