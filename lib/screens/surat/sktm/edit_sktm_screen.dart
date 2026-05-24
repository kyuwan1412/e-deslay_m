import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/api_service.dart';

class EditSKTMScreen extends StatefulWidget {

  final Map<String, dynamic> data;

  const EditSKTMScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditSKTMScreen> createState() =>
      _EditSKTMScreenState();
}

class _EditSKTMScreenState
    extends State<EditSKTMScreen> {

  final formKey =
  GlobalKey<FormState>();

  bool isLoading = false;

  final namaController =
  TextEditingController();

  final nikController =
  TextEditingController();

  final hpController =
  TextEditingController();

  final alamatController =
  TextEditingController();

  final tanggunganController =
  TextEditingController();

  final ekonomiController =
  TextEditingController();

  final tujuanController =
  TextEditingController();

  File? imageFile;

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

    tanggunganController.text =
        widget.data['jumlah_tanggungan']
            ?.toString() ??
            "";

    ekonomiController.text =
        widget.data['status_ekonomi'] ?? "";

    tujuanController.text =
        widget.data['tujuan_skmt'] ?? "";
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

    if (mounted) {

      setState(() {
        isLoading = false;
      });
    }

    final Map<String, dynamic> data = {

      "nama_lengkap":
      namaController.text,

      "nik":
      nikController.text,

      "no_hp":
      hpController.text,

      "alamat":
      alamatController.text,

      "jumlah_tanggungan":
      tanggunganController.text,

      "status_ekonomi":
      ekonomiController.text,

      "tujuan_skmt":
      tujuanController.text,
    };

    if (imageFile != null) {

      data["dokumen_scan"] =
          imageFile!.path;
    }

    final response =
    await ApiService.updateSKTM(

      widget.data['id'],
      data,
    );

    if (mounted) {

      setState(() {
        isLoading = false;
      });
    }

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
            response['message'] ??
                'Terjadi kesalahan',
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

        backgroundColor:
        const Color(0xFF1565C0),

        title: const Text(

          "Edit Pengajuan SKTM",

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
          const EdgeInsets.all(
            20,
          ),

          child: Column(
            children: [

              // ================= FOTO =================
              GestureDetector(

                onTap: pickImage,

                child: Container(

                  width: double.infinity,
                  height: 190,

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

                        Icons.cloud_upload,

                        size: 60,

                        color:
                        Colors.grey.shade400,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        "Upload Ulang Dokumen",

                        style: TextStyle(
                          color:
                          Colors.grey.shade600,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ================= FORM =================
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
                "Jumlah Tanggungan",
                tanggunganController,
              ),

              field(
                "Status Ekonomi",
                ekonomiController,
              ),

              field(
                "Tujuan SKTM",
                tujuanController,
                maxLines: 3,
              ),

              const SizedBox(
                height: 30,
              ),

              // ================= BUTTON =================
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

                      ? const SizedBox(

                    width: 24,
                    height: 24,

                    child:
                    CircularProgressIndicator(
                      color:
                      Colors.white,
                      strokeWidth:
                      2,
                    ),
                  )

                      : const Text(

                    "SIMPAN PERUBAHAN",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.bold,

                      fontSize: 15,
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
      ),
    );
  }

  @override
  void dispose() {

    namaController.dispose();

    nikController.dispose();

    hpController.dispose();

    alamatController.dispose();

    tanggunganController.dispose();

    ekonomiController.dispose();

    tujuanController.dispose();

    super.dispose();
  }

  // ================= FIELD =================
  Widget field(
      String title,
      TextEditingController controller, {

        int maxLines = 1,
      }) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 22,
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ================= LABEL =================
          Padding(

            padding:
            const EdgeInsets.only(
              left: 4,
              bottom: 10,
            ),

            child: Text(

              title,

              style: const TextStyle(

                fontSize: 14,

                fontWeight:
                FontWeight.w700,

                color:
                Color(0xFF1E293B),
              ),
            ),
          ),

          // ================= INPUT =================
          TextFormField(

            controller: controller,

            maxLines: maxLines,

            validator: (v) {

              if (v == null ||
                  v.trim().isEmpty) {

                return "$title wajib diisi";
              }

              return null;
            },

            style: const TextStyle(

              fontSize: 15,

              fontWeight:
              FontWeight.w500,
            ),

            decoration: InputDecoration(

              hintText:
              "Masukkan $title",

              hintStyle: TextStyle(
                color:
                Colors.grey.shade400,
              ),

              filled: true,

              fillColor:
              Colors.white,

              contentPadding:
              const EdgeInsets.symmetric(

                horizontal: 20,
                vertical: 20,
              ),

              border:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                  22,
                ),

                borderSide:
                BorderSide.none,
              ),

              enabledBorder:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                  22,
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
                  22,
                ),

                borderSide:
                const BorderSide(

                  color:
                  Color(0xFF1565C0),

                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}