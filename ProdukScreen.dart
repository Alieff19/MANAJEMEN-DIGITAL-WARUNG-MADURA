import 'package:flutter/material.dart';
import 'package:demo/TambahBarang.dart';
import 'package:demo/UbahStok.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({Key? key}) : super(key: key);

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  List<dynamic> produkList = [];

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/produk'));

      if (response.statusCode == 200) {
        setState(() {
          produkList = json.decode(response.body);
        });
      } else {
        print('Gagal mengambil data produk. Kode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat mengambil data produk: $e');
    }
  }

  Future<void> _navigateToTambahBarang() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahBarang(),
      ),
    );
    if (result == true) {
      fetchProduk(); // refresh data jika berhasil tambah
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 118,
              color: const Color.fromRGBO(255, 201, 201, 1),
              padding: const EdgeInsets.only(top: 46, left: 20),
              child: Row(
                children: [
                  const Text(
                    'Produk',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/produk2.png', width: 50, height: 50),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List Produk
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9.4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4.55),
                        blurRadius: 16.4,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 201, 201, 1),
                          borderRadius: BorderRadius.circular(9.4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Nama Produk',
                                style: TextStyle(
                                  color: Color.fromRGBO(184, 19, 19, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Stok',
                                style: TextStyle(
                                  color: Color.fromRGBO(184, 19, 19, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Aksi',
                                style: TextStyle(
                                  color: Color.fromRGBO(184, 19, 19, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...produkList.map((produk) => _productRow(
                        context,
                        produk['id'], // produkId
                        produk['nama'],
                        '${produk['stok']} ${produk['satuan']}',
                      )),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _navigateToTambahBarang,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4.55),
                                blurRadius: 9.3,
                              )
                            ],
                            color: const Color.fromRGBO(184, 19, 19, 1),
                            border: Border.all(
                              color: const Color.fromRGBO(184, 19, 19, 1),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: const Text(
                            'Tambah Barang',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productRow(BuildContext context, int produkId, String productName, String stock) {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              productName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              stock,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ubahstok(produkId: produkId), // tanpa const
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/Plus.png',
                width: 16,
                height: 16,
              ),
              label: const Text(
                'Ubah',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
