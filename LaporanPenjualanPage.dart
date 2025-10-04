import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LaporanPenjualanPage extends StatefulWidget {
  const LaporanPenjualanPage({super.key});

  @override
  State<LaporanPenjualanPage> createState() => _LaporanPenjualanPageState();
}

class _LaporanPenjualanPageState extends State<LaporanPenjualanPage> {
  List<dynamic> transaksiHariIni = [];
  List<dynamic> semuaItems = [];
  bool isLoading = true;
  String? errorMessage;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    fetchTransaksiHariIni();
  }

  Future<void> fetchTransaksiHariIni() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/transaksi/today'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          List<dynamic> itemsGabungan = [];
          for (var transaksi in data) {
            if (transaksi['items'] != null && transaksi['items'] is List) {
              itemsGabungan.addAll(transaksi['items']);
            }
          }
          setState(() {
            transaksiHariIni = data;
            semuaItems = itemsGabungan;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Format data tidak sesuai";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Gagal memuat data transaksi: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  double get totalHarga {
    double total = 0;
    for (var produk in semuaItems) {
      double jumlah = 0;
      double harga = 0;

      final rawJumlah = produk['jumlah'];
      final rawHarga = produk['harga'];

      if (rawJumlah is int) {
        jumlah = rawJumlah.toDouble();
      } else if (rawJumlah is double) {
        jumlah = rawJumlah;
      } else if (rawJumlah is String) {
        jumlah = double.tryParse(rawJumlah.split(' ').first) ?? 0;
      }

      if (rawHarga is int) {
        harga = rawHarga.toDouble();
      } else if (rawHarga is double) {
        harga = rawHarga;
      } else if (rawHarga is String) {
        harga = double.tryParse(rawHarga) ?? 0;
      }

      total += jumlah * harga;
    }
    return total;
  }

  int get jumlahProdukTerjual {
    int total = 0;
    for (var produk in semuaItems) {
      int jumlah = 0;
      var jumlahRaw = produk['jumlah'];
      if (jumlahRaw is int) {
        jumlah = jumlahRaw;
      } else if (jumlahRaw is String) {
        jumlah = int.tryParse(jumlahRaw.split(' ').first) ?? 0;
      }
      total += jumlah;
    }
    return total;
  }

  int get jumlahTransaksi => transaksiHariIni.length;

  String formatHarga(dynamic harga) {
    if (harga == null) return currencyFormatter.format(0);

    if (harga is int) {
      return currencyFormatter.format(harga);
    } else if (harga is String) {
      final parsed = double.tryParse(harga);
      return currencyFormatter.format(parsed ?? 0);
    } else if (harga is double) {
      return currencyFormatter.format(harga);
    }
    return currencyFormatter.format(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        backgroundColor: const Color(0xFFFEE5E5),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
          child: Text(errorMessage!,
              style: const TextStyle(color: Colors.red)))
          : Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Hari Ini',
              style: TextStyle(
                color: Color.fromRGBO(184, 19, 19, 1),
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: semuaItems.isEmpty
                  ? const Center(
                child: Text(
                  'Tidak ada produk terjual hari ini',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: semuaItems.length,
                itemBuilder: (context, index) {
                  final produk = semuaItems[index];
                  final nama =
                      produk['namaProduk']?.toString() ?? '';
                  final jumlahRaw = produk['jumlah'];
                  String jumlah = '';
                  if (jumlahRaw is String) {
                    jumlah = jumlahRaw;
                  } else if (jumlahRaw is int) {
                    jumlah = '$jumlahRaw pcs';
                  } else {
                    jumlah = '0 pcs';
                  }
                  final harga =
                  formatHarga(produk['harga']);
                  return _itemTransaksi(nama, jumlah, harga);
                },
              ),
            ),
            const Divider(thickness: 1, height: 20),
            _totalRow("TOTAL PENJUALAN", formatHarga(totalHarga)),
            const SizedBox(height: 8),
            _infoRow(
                "Jumlah Transaksi", "$jumlahTransaksi transaksi"),
            _infoRow("Jumlah Produk Terjual",
                "$jumlahProdukTerjual produk"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _itemTransaksi(String nama, String jumlah, String harga) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              nama,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              jumlah,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              harga,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              total,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
