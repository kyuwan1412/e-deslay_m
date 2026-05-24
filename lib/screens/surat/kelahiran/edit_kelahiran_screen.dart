import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/api_service.dart';

class EditKelahiranScreen extends StatefulWidget {

  final Map<String, dynamic> data;

  const EditKelahiranScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditKelahiranScreen> createState() =>
      _EditKelahiranScreenState();
}

class _EditKelahiranScreenState
    extends State<EditKelahiranScreen> {

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

  final namaBayiController =
  TextEditingController();

  final tempatLahirController =
  TextEditingController();

  final tanggalLahirController =
  TextEditingController();

  final jkController =
  TextEditingController();

  final waktuController =
  TextEditingController();

  final ayahController =
  TextEditingController();

  final ibuController =
  TextEditingController();

  final nikAyahController =
  TextEditingController();

  final nikIbuController =
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

    namaBayiController.text =
        widget.data['nama_bayi'] ?? "";

    tempatLahirController.text =
        widget.data['tempat_lahir_bayi'] ?? "";

    tanggalLahirController.text =
        widget.data['tanggal_lahir_bayi'] ?? "";

    jkController.text =
        widget.data['jenis_kelamin_bayi'] ?? "";

    waktuController.text =
        widget.data['waktu_lahir'] ?? "";

    ayahController.text =
        widget.data['nama_ayah'] ?? "";

    ibuController.text =
        widget.data['nama_ibu'] ?? "";

    nikAyahController.text =
        widget.data['nik_ayah'] ?? "";

    nikIbuController.text =
        widget.data['nik_ibu'] ?? "";
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
    await ApiService.updateKelahiran(

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

        "nama_bayi":
        namaBayiController.text,

        "tempat_lahir_bayi":
        tempatLahirController.text,

        "tanggal_lahir_bayi":
        tanggalLahirController.text,

        "jenis_kelamin_bayi":
        jkController.text,

        "waktu_lahir":
        waktuController.text,

        "nama_ayah":
        ayahController.text,

        "nama_ibu":
        ibuController.text,

        "nik_ayah":
        nikAyahController.text,

        "nik_ibu":
        nikIbuController.text,

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

          "Edit Surat Kelahiran",

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

                        Icons.child_care,

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

                      const SizedBox(
                        height: 5,
                      ),

                      Text(

                        "Tap untuk memilih gambar",

                        style: TextStyle(
                          color:
                          Colors.grey.shade600,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

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
                "Nama Bayi",
                namaBayiController,
              ),

              field(
                "Tempat Lahir Bayi",
                tempatLahirController,
              ),

              field(
                "Tanggal Lahir Bayi",
                tanggalLahirController,
              ),

              field(
                "Jenis Kelamin Bayi",
                jkController,
              ),

              field(
                "Waktu Lahir",
                waktuController,
              ),

              field(
                "Nama Ayah",
                ayahController,
              ),

              field(
                "NIK Ayah",
                nikAyahController,
              ),

              field(
                "Nama Ibu",
                ibuController,
              ),

              field(
                "NIK Ibu",
                nikIbuController,
              ),

              const SizedBox(
                height: 34,
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

  // ================= FIELD =================
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

              fontSize: 14,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

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