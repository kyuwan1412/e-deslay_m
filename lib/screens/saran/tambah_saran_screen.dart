import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';

class TambahSaranScreen extends StatefulWidget {
  const TambahSaranScreen({super.key});

  @override
  State<TambahSaranScreen> createState() =>
      _TambahSaranScreenState();
}

class _TambahSaranScreenState
    extends State<TambahSaranScreen> {

  final judulController = TextEditingController();
  final isiController = TextEditingController();

  File? imageFile;

  bool isLoading = false;

  Future<void> pickImage() async {

    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {

      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> kirimSaran() async {

    if (judulController.text.isEmpty ||
        isiController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Judul dan isi saran wajib diisi",
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final user =
    await SessionService.getUser();

    setState(() {
      isLoading = true;
    });

    final result =
    await ApiService.tambahSaran(
      email: user['email'],
      judul: judulController.text,
      isiSaran: isiController.text,
      foto: imageFile,
    );

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      body: Column(
        children: [

          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              22,
              55,
              22,
              35,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2E6BE6),
                  Color(0xFF4B88FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Row(
              children: [

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Tambah Saran",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "Sampaikan masukan terbaik Anda",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(26),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Judul Saran",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _input(judulController),

                    const SizedBox(height: 22),

                    const Text(
                      "Isi Saran",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: isiController,
                      maxLines: 6,

                      decoration: InputDecoration(
                        hintText:
                        "Tulis saran Anda di sini...",

                        filled: true,
                        fillColor:
                        const Color(0xFFF8FAFF),

                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(18),

                          borderSide: BorderSide.none,
                        ),

                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.blue.shade50,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Foto Pendukung",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: pickImage,

                      child: Container(
                        height: 210,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color:
                          const Color(0xFFF8FAFF),

                          borderRadius:
                          BorderRadius.circular(24),

                          border: Border.all(
                            color:
                            const Color(0xFFDCE8FF),
                            width: 1.3,
                          ),
                        ),

                        child: imageFile != null

                            ? ClipRRect(
                          borderRadius:
                          BorderRadius.circular(24),

                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )

                            : Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            Container(
                              width: 72,
                              height: 72,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(22),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue
                                        .withOpacity(0.10),
                                    blurRadius: 10,
                                    offset:
                                    const Offset(0, 4),
                                  )
                                ],
                              ),

                              child: const Icon(
                                Icons
                                    .photo_camera_back_rounded,
                                size: 38,
                                color:
                                Color(0xFF2E6BE6),
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              "Tambah Foto",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w800,
                                color:
                                Color(0xFF2E6BE6),
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "PNG, JPG atau JPEG",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                          const Color(0xFF2E6BE6),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                        ),

                        onPressed:
                        isLoading
                            ? null
                            : kirimSaran,

                        child: isLoading

                            ? const SizedBox(
                          width: 24,
                          height: 24,

                          child:
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )

                            : const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "KIRIM SARAN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.w800,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _input(
      TextEditingController controller,
      ) {

    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: "Masukkan judul...",

        filled: true,
        fillColor: const Color(0xFFF8FAFF),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
      ),
    );
  }
}