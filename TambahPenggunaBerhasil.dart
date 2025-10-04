import 'package:flutter/material.dart';
import 'PenggunaPage.dart'; // Pastikan import file Pengguna.dart

class TambahPenggunaBerhasil extends StatelessWidget {
  final Map<String, dynamic> dataBaru; // Data baru yang ditambahkan

  const TambahPenggunaBerhasil({
    super.key,
    required this.dataBaru,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Latar belakang utama
          Container(
            width: 411,
            height: 731,
            color: const Color(0xFFFFFFFF),
          ),

          // Header merah muda
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 430,
              height: 125,
              color: const Color(0xFFFFC9C9),
              child: const Padding(
                padding: EdgeInsets.only(top: 45, left: 67),
                child: Text(
                  'Tambah Pengguna',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 30,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),

          // Kotak utama
          Positioned(
            top: 236,
            left: 49,
            child: Container(
              width: 317,
              height: 220.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Header kotak
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 317,
                      height: 41.6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC9C9),
                        borderRadius: BorderRadius.circular(8.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.13),
                            offset: const Offset(0, 3.6),
                            blurRadius: 7.2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Tambah Pengguna',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.3,
                            color: Color(0xFFB81313),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tombol kembali
                  Positioned(
                    top: 158,
                    left: 100,
                    child: GestureDetector(
                      onTap: () {
                        // Kembali ke halaman Pengguna.dart dengan data baru
                        Navigator.pop(context, dataBaru);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.2, vertical: 2.14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBFB),
                          borderRadius: BorderRadius.circular(11.78),
                          border: Border.all(
                            color: const Color(0xFFD1D1D1),
                            width: 0.45,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              offset: const Offset(0, 4.28),
                              blurRadius: 9.96,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Kembali',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Teks berhasil
                  const Positioned(
                    top: 101,
                    left: 73,
                    child: Text(
                      'Tambah Pengguna Berhasil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.8,
                        color: Color(0xFFB81313),
                        height: 1,
                      ),
                    ),
                  ),

                  // Ikon vector
                  Positioned(
                    top: 100,
                    left: 237,
                    child: Image.asset(
                      'assets/images/ceklis.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
