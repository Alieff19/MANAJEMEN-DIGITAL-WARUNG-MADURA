import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPengguna extends StatefulWidget {
  final int userId;
  final String initialNama;
  final String initialUsername;
  final String initialPassword;

  const EditPengguna({
    Key? key,
    required this.userId,
    required this.initialNama,
    required this.initialUsername,
    required this.initialPassword,
  }) : super(key: key);

  @override
  _EditPenggunaState createState() => _EditPenggunaState();
}

class _EditPenggunaState extends State<EditPengguna> {
  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.initialNama);
    usernameController = TextEditingController(text: widget.initialUsername);
    passwordController = TextEditingController(text: widget.initialPassword);
  }

  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> simpanPerubahan() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://10.0.2.2:8080/api/users/${widget.userId}');

    final body = jsonEncode({
      'nama': namaController.text,
      'username': usernameController.text,
      'password': passwordController.text,
    });

    print('PUT URL: $url');
    print('Request body: $body');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context, true);
      } else {
        _showError('Gagal menyimpan perubahan. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> hapusPengguna() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://10.0.2.2:8080/api/users/${widget.userId}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context, true);
      } else {
        _showError('Gagal menghapus pengguna. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 411,
        height: 731,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 430,
                height: 125,
                color: const Color(0xFFFEE5E5),
                child: const Center(
                  child: Text(
                    'Edit Pengguna',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 236,
              left: 48,
              child: Container(
                width: 316,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 15.2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC9C9),
                        borderRadius: BorderRadius.circular(8.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.13),
                            offset: Offset(0, 3.6),
                            blurRadius: 7.2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Edit Pengguna',
                          style: TextStyle(
                            color: Color(0xFFB81313),
                            fontFamily: 'Poppins',
                            fontSize: 13.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'NAMA PENGGUNA',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _editableField(namaController),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'USERNAME',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _editableField(usernameController),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PASSWORD',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _editableField(passwordController, obscure: true),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _actionButton('HAPUS', const Color(0xFFD72825), Colors.white, hapusPengguna),
                          _actionButton('BATAL', const Color(0xFFFFFBFB), Colors.black, () {
                            Navigator.pop(context, false);
                          }),
                          _actionButton('SIMPAN', const Color(0xFF05AF81), Colors.white, simpanPerubahan),
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

  Widget _editableField(TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 10),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFBFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.2),
          borderSide: const BorderSide(color: Color(0xFFD1D1D1), width: 0.4),
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color bgColor, Color textColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD1D1D1), width: 0.45),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              offset: Offset(0, 4.28),
              blurRadius: 9.96,
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
