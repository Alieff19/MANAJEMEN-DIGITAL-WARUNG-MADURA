import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'TambahPenggunaBerhasil.dart';

class TambahPengguna extends StatelessWidget {
  TambahPengguna({super.key});

  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> simpanPengguna(BuildContext context) async {
    final String namaPengguna = namaController.text; // input user
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Ganti IP sesuai backend-mu
    final url = Uri.parse('http://10.0.2.2:8080/api/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'nama': namaPengguna, // update: kirim 'nama'
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dataBaru = jsonDecode(response.body);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TambahPenggunaBerhasil(dataBaru: dataBaru),
          ),
        );
      } else {
        _showErrorDialog(context, 'Gagal menambahkan pengguna. Coba lagi.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Terjadi kesalahan: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(height: 125, color: const Color(0xFFFEE5E5)),
            ),
            const Positioned(
              top: 52,
              left: 74,
              child: Text(
                'Tambah Pengguna',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontSize: 30,
                ),
              ),
            ),
            Positioned(
              top: 223,
              left: 48,
              child: Container(
                width: 316,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                            color: Color(0xFFB81313),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('NAMA PENGGUNA', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    ),
                    const SizedBox(height: 4),
                    buildInputField(controller: namaController, hintText: 'Mak Ijah'),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('USERNAME', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    ),
                    const SizedBox(height: 4),
                    buildInputField(controller: usernameController, hintText: 'ijahkeren@example.com'),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('PASSWORD', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    ),
                    const SizedBox(height: 4),
                    buildInputField(controller: passwordController, hintText: 'ijah12345', obscureText: true),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildButton(
                          text: 'BATAL',
                          color: const Color(0xFFFFFBFB),
                          textColor: Colors.black,
                          onPressed: () => Navigator.pop(context),
                        ),
                        buildButton(
                          text: 'SIMPAN',
                          color: const Color(0xFF05AF81),
                          textColor: Colors.white,
                          onPressed: () => simpanPengguna(context),
                        ),
                      ],
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

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        border: Border.all(color: const Color(0xFFD1D1D1), width: 0.4),
        borderRadius: BorderRadius.circular(6.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD1D1D1), width: 0.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(0, 4.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
