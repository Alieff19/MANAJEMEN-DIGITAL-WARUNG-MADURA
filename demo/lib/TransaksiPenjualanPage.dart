import 'dart:convert';
import 'package:demo/TransaksiSuksesWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Produk {
  final int id;
  final String nama;
  final double hargaJual;

  Produk({
    required this.id,
    required this.nama,
    required this.hargaJual,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama: json['nama'],
      hargaJual: (json['hargaJual'] as num).toDouble(),
    );
  }
}

class ItemTransaksi {
  final Produk produk;
  int quantity;

  ItemTransaksi({required this.produk, this.quantity = 1});

  double get subtotal => produk.hargaJual * quantity;
}

class TransaksiPenjualanPage extends StatefulWidget {
  const TransaksiPenjualanPage({super.key});

  @override
  _TransaksiPenjualanPageState createState() => _TransaksiPenjualanPageState();
}

class _TransaksiPenjualanPageState extends State<TransaksiPenjualanPage> {
  final TextEditingController searchController = TextEditingController();
  List<Produk> hasilPencarian = [];
  List<ItemTransaksi> keranjang = [];
  String metodePembayaran = 'Tunai'; // default metode bayar

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.trim();
    if (query.isNotEmpty) {
      _cariProduk(query);
    } else {
      setState(() {
        hasilPencarian.clear();
      });
    }
  }

  Future<void> _cariProduk(String query) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/api/produk');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Produk> semuaProduk =
        data.map((json) => Produk.fromJson(json)).toList();

        List<Produk> hasil = semuaProduk
            .where((produk) =>
            produk.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();

        setState(() {
          hasilPencarian = hasil;
        });
      } else {
        print('Gagal fetch produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetch produk: $e');
    }
  }

  void _tambahKeKeranjang(Produk produk) {
    int index = keranjang.indexWhere((item) => item.produk.id == produk.id);
    setState(() {
      if (index == -1) {
        keranjang.add(ItemTransaksi(produk: produk));
      } else {
        keranjang[index].quantity++;
      }
      searchController.clear();
      hasilPencarian.clear();
    });
  }

  double get _subtotal {
    return keranjang.fold(0, (sum, item) => sum + item.subtotal);
  }

  void _ubahQuantity(ItemTransaksi item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity < 1) {
        keranjang.remove(item);
      }
    });
  }

  Future<void> _prosesTransaksi() async {
    if (keranjang.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang kosong')),
      );
      return;
    }

    // Membangun JSON sesuai kebutuhan backend
    final transaksiData = {
      "items": keranjang.map((item) {
        return {
          "produkId": item.produk.id,
          "jumlah": item.quantity,
          "harga": item.produk.hargaJual,
        };
      }).toList(),
      "pembayaran": metodePembayaran,
    };

    try {
      final url = Uri.parse('http://10.0.2.2:8080/api/transaksi');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(transaksiData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          keranjang.clear();
          metodePembayaran = 'Tunai';
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransaksiSuksesWidget()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal transaksi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error transaksi: $e')),
      );
    }
  }

  void _setMetodePembayaran(String metode) {
    setState(() {
      metodePembayaran = metode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            Container(height: 80, width: double.infinity, color: const Color(0xFFFEE5E5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaksi Penjualan',
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(
                            'assets/images/transaksipenjualan.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search bar
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFFFFBFB),
                        border: Border.all(color: const Color(0xFFD1D1D1), width: 1),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset(
                              'assets/images/cari.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: 'Cari Produk',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hasil pencarian produk
                    if (hasilPencarian.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFD8D1D1)),
                        ),
                        child: Column(
                          children: hasilPencarian.map((produk) {
                            return ListTile(
                              title: Text(produk.nama,
                                  style: const TextStyle(fontFamily: 'Poppins')),
                              trailing: Text('Rp${produk.hargaJual.toStringAsFixed(0)}',
                                  style: const TextStyle(fontFamily: 'Poppins')),
                              onTap: () => _tambahKeKeranjang(produk),
                            );
                          }).toList(),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Daftar keranjang
                    if (keranjang.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD8D1D1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Daftar Produk',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            ...keranjang.map((item) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(item.produk.nama,
                                          style:
                                          const TextStyle(fontFamily: 'Poppins'))),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline,
                                            color: Colors.red),
                                        onPressed: () => _ubahQuantity(item, -1),
                                      ),
                                      Text(item.quantity.toString(),
                                          style: const TextStyle(fontFamily: 'Poppins')),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline,
                                            color: Colors.green),
                                        onPressed: () => _ubahQuantity(item, 1),
                                      ),
                                    ],
                                  ),
                                  Text('Rp${item.subtotal.toStringAsFixed(0)}',
                                      style: const TextStyle(fontFamily: 'Poppins')),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                    const SizedBox(height: 15),

                    // Subtotal
                    _labelWithValue('Subtotal', 'Rp${_subtotal.toStringAsFixed(0)}'),

                    const SizedBox(height: 15),

                    // Pembayaran (jumlah pembayaran disamakan dengan subtotal untuk saat ini)
                    _labelWithValue('Pembayaran', 'Rp${_subtotal.toStringAsFixed(0)}'),

                    const SizedBox(height: 15),

                    // Metode pembayaran
                    const Text(
                      'Metode Pembayaran',
                      style:
                      TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _metodePembayaranButton('Tunai'),
                        const SizedBox(width: 10),
                        _metodePembayaranButton('QRIS'),
                      ],
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _prosesTransaksi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEE5555),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Proses Transaksi',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelWithValue(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _metodePembayaranButton(String metode) {
    final isSelected = metodePembayaran == metode;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _setMetodePembayaran(metode),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFEE5555) : Colors.white,
          side: BorderSide(
              color: isSelected ? Colors.transparent : const Color(0xFFEE5555)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          metode,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFFEE5555),
          ),
        ),
      ),
    );
  }
}
