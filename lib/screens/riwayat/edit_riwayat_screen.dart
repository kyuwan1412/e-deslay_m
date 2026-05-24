import 'package:flutter/material.dart';

class EditRiwayatScreen extends StatefulWidget {

  final Map<String, dynamic> item;

  const EditRiwayatScreen({
    super.key,
    required this.item,
  });

  @override
  State<EditRiwayatScreen> createState() =>
      _EditRiwayatScreenState();
}

class _EditRiwayatScreenState
    extends State<EditRiwayatScreen> {

  late TextEditingController namaController;

  @override
  void initState() {
    super.initState();

    namaController =
        TextEditingController(
          text:
          widget.item['data']
          ['nama_lengkap']
              ?.toString() ??
              "",
        );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F7FC),

      appBar: AppBar(
        title:
        const Text("Edit Pengajuan"),
      ),

      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(

              padding:
              const EdgeInsets.all(20),

              decoration:
              BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  28,
                ),
              ),

              child: Column(
                children: [

                  TextFormField(
                    controller:
                    namaController,

                    decoration:
                    InputDecoration(
                      labelText:
                      "Nama Lengkap",

                      filled: true,

                      fillColor:
                      const Color(
                        0xFFF5F7FB,
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
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

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
                          0xFF2B6BFF,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      onPressed: () {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(

                          const SnackBar(
                            content: Text(
                              "Update berhasil",
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}