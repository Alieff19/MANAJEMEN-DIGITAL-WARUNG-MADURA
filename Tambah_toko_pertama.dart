import 'package:flutter/material.dart';
import 'tambah_toko_kedua.dart'; // pastikan file ini ada

class Tambah_toko_pertama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 411,
        height: 731,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 411,
                height: 731,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Stack(
                  children: <Widget>[
                    // Header merah
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 426,
                        height: 118,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 201, 201, 1),
                        ),
                      ),
                    ),
                    // Judul
                    Positioned(
                      top: 38,
                      left: 85,
                      child: Text(
                        'Tambah Toko',
                        style: TextStyle(
                          color: Color.fromRGBO(184, 19, 19, 1),
                          fontFamily: 'Inter',
                          fontSize: 34,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                    // Subjudul
                    Positioned(
                      top: 129,
                      left: 98,
                      child: Text(
                        'TOKO MILIK ANDA',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                    // Contoh toko yang sudah ada
                    Positioned(
                      top: 175,
                      left: 64,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: Offset(0, 4.5),
                              blurRadius: 16,
                            ),
                          ],
                          color: Color.fromRGBO(184, 19, 19, 1),
                          border: Border.all(
                            color: Color.fromRGBO(184, 19, 19, 1),
                            width: 1,
                          ),
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'TOKO A',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tombol Tambahkan Toko
                    Positioned(
                      top: 499,
                      left: 71,
                      child: GestureDetector(
                        onTap: () {
                          // Arahkan ke halaman tambah_toko_kedua
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Tambah_toko_kedua(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 4.5),
                                blurRadius: 16,
                              ),
                            ],
                            color: Color.fromRGBO(184, 19, 19, 1),
                            border: Border.all(
                              color: Color.fromRGBO(184, 19, 19, 1),
                              width: 1,
                            ),
                          ),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text(
                            'TAMBAHKAN TOKO',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
