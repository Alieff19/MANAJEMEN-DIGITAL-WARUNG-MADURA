import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Halaman target yang dituju setelah selesai atau back
class TransaksiPenjualanPage extends StatelessWidget {
  const TransaksiPenjualanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Penjualan'),
        backgroundColor: const Color.fromRGBO(255, 201, 201, 1),
      ),
      body: const Center(
        child: Text('Ini halaman Transaksi Penjualan'),
      ),
    );
  }
}

// Widget Transaksi Sukses lengkap dengan tombol kembali dan tombol selesai
class TransaksiSuksesWidget extends StatelessWidget {
  const TransaksiSuksesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Tangani tombol back fisik agar diarahkan ke TransaksiPenjualanPage
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TransaksiPenjualanPage()),
        );
        return false; // cegah pop default
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            // Header merah muda
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 201, 201, 1),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 45, left: 13),
                  child: Text(
                    'Transaksi Penjualan',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 30.08,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),

            // Icon SVG di kanan atas
            Positioned(
              top: 42,
              right: 35,
              child: SvgPicture.asset(
                'assets/images/transaksipenjualan.svg',
                semanticsLabel: 'vector',
                width: 28,
                height: 28,
              ),
            ),

            // Text sukses transaksi di tengah horizontal, vertical 274 px dari atas
            const Positioned(
              top: 274,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Transaksi Telah Sukses !!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(184, 19, 19, 1),
                    fontFamily: 'Inter',
                    fontSize: 21.69,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ),

            // Tombol Selesai di tengah horizontal, vertical 359 px dari atas
            Positioned(
              top: 359,
              left: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () {
                    // Ubah jadi pop ke halaman sebelumnya
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(184, 19, 19, 1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromRGBO(184, 19, 19, 1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4.55),
                          blurRadius: 16.4,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Selesai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.9,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main function untuk coba jalankan widget
void main() {
  runApp(const MaterialApp(
    home: TransaksiSuksesWidget(),
  ));
}
