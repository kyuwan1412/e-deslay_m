import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/api_service.dart';

class EditDomisiliScreen extends StatefulWidget {

  final Map<String, dynamic> data;

  const EditDomisiliScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditDomisiliScreen> createState() =>
      _EditDomisiliScreenState();
}

class _EditDomisiliScreenState
    extends State<EditDomisiliScreen> {

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

  final tempatTinggalController =
  TextEditingController();

  final keperluanController =
  TextEditingController();

  String metodePengambilan =
      "ambil_desa";

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

    tempatTinggalController.text =
        widget.data['tempat_tinggal'] ?? "";

    keperluanController.text =
        widget.data['keperluan'] ?? "";

    metodePengambilan =
        widget.data['metode_pengambilan']
            ?? "ambil_desa";
  }

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {

    final picked =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
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
    await ApiService.updateDomisili(

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

        "tempat_tinggal":
        tempatTinggalController.text,

        "keperluan":
        keperluanController.text,

        "metode_pengambilan":
        metodePengambilan,

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
            "Data domisili berhasil diperbarui",
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

        backgroundColor:
        const Color(0xFF1565C0),

        centerTitle: true,

        title: const Text(

          "Edit Surat Domisili",

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

                        Icons.home_work_rounded,

                        size: 60,

                        color:
                        Colors.blue.shade300,
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
                        height: 4,
                      ),

                      Text(

                        "Tap untuk pilih gambar",

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
                "Alamat Lengkap",
                alamatController,
                maxLines: 3,
              ),

              field(
                "Tempat Tinggal",
                tempatTinggalController,
              ),

              field(
                "Keperluan Surat",
                keperluanController,
                maxLines: 3,
              ),

              const SizedBox(
                height: 4,
              ),

              // ================= METODE =================
              Align(
                alignment:
                Alignment.centerLeft,

                child: Text(

                  "Metode Pengambilan",

                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Colors.grey.shade800,
                    fontSize: 14,
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
                    18,
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

                    isExpanded: true,

                    items: const [

                      DropdownMenuItem(
                        value:
                        'ambil_desa',

                        child: Text(
                          'Ambil di Kantor Desa',
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                        'cetak_online',

                        child: Text(
                          'Cetak Online',
                        ),
                      ),
                    ],

                    onChanged: (v) {

                      setState(() {

                        metodePengambilan =
                        v!;
                      });
                    },
                  ),
                ),
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