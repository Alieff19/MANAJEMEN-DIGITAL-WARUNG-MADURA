import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ProdukScreen.dart';
import 'TransaksiPenjualanPage.dart';
import 'PenggunaPage.dart';
import 'LaporanPenjualanPage.dart';
import 'Logout.dart'; // pastikan file ini ada

class DashboardWidget extends StatelessWidget {
  final String role; // role user: "ADMIN" atau "KASIR"

  const DashboardWidget({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(
          children: <Widget>[
            // Logo
            Positioned(
              top: 81,
              left: 34,
              child: Container(
                width: 59,
                height: 59,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // Judul Aplikasi
            const Positioned(
              top: 100,
              left: 126,
              child: Text(
                'WARUNGIN',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(184, 19, 19, 1),
                  fontFamily: 'Inter',
                  fontSize: 25.91,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // Icon Titik Tiga (Logout)
            Positioned(
              top: 92,
              left: 320,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogOut()),
                  );
                },
                child: Container(
                  width: 44.47,
                  height: 43.19,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: const BorderRadius.all(
                      Radius.elliptical(44.47, 43.19),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/titiktiga.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // Menu Transaksi Penjualan
            _buildCustomCard(
              context: context,
              top: 201,
              left: 93,
              width: 244,
              height: 57,
              iconTop: 20.48,
              iconLeft: 13,
              textTop: 19.24,
              textLeft: 64.71,
              iconPath: 'assets/images/transaksipenjualan.svg',
              text: 'Transaksi Penjualan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransaksiPenjualanPage(),
                  ),
                );
              },
            ),

            // Menu Produk
            _buildCustomCard(
              context: context,
              top: 310,
              left: 93,
              width: 244,
              height: 56,
              iconTop: 8.35,
              iconLeft: 17.49,
              textTop: 17.49,
              textLeft: 113.69,
              iconPath: 'assets/images/produk.png',
              text: 'Produk',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProdukScreen(),
                  ),
                );
              },
            ),

            // Menu Pengguna (ADMIN only)
            if (role == 'ADMIN')
              _buildCustomCard(
                context: context,
                top: 415,
                left: 93,
                width: 244,
                height: 57,
                iconTop: 16.07,
                iconLeft: 19.07,
                textTop: 18.53,
                textLeft: 108.65,
                iconPath: 'assets/images/pengguna.png',
                text: 'Pengguna',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PenggunaPage(),
                    ),
                  );
                },
              ),

            // Menu Laporan Penjualan (ADMIN only)
            if (role == 'ADMIN')
              _buildCustomCard(
                context: context,
                top: 522,
                left: 94,
                width: 244,
                height: 57,
                iconTop: 18.26,
                iconLeft: 15.10,
                textTop: 17.86,
                textLeft: 78.70,
                iconPath: 'assets/images/laporanpenjualan.png',
                text: 'Laporan Penjualan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LaporanPenjualanPage(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCard({
    required BuildContext context,
    required double top,
    required double left,
    required double width,
    required double height,
    required double iconTop,
    required double iconLeft,
    required double textTop,
    required double textLeft,
    required String text,
    String? iconPath,
    VoidCallback? onTap,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 242, 242, 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 3.5),
                blurRadius: 12.5,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              if (iconPath != null)
                Positioned(
                  top: iconTop,
                  left: iconLeft,
                  child: iconPath.endsWith('.svg')
                      ? SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    semanticsLabel: 'icon',
                  )
                      : Image.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              Positioned(
                top: textTop,
                left: textLeft,
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
