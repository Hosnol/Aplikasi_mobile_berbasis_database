import 'package:flutter/material.dart';
import 'package:aplikasi_berbasis_database/database/DatabaseHelper.dart';
import 'package:aplikasi_berbasis_database/session/session_utils.dart';

class pengaturan extends StatefulWidget {
  @override
  _pengaturanState createState() => _pengaturanState();
}

class _pengaturanState extends State<pengaturan> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  // Fungsi untuk memeriksa apakah password saat ini benar
  Future<bool> isCurrentPasswordValid() async {
    // Mengambil password saat ini dari controller
    String currentPassword = currentPasswordController.text;

    // Mengambil username dari sesi
    String? username = await getUsernameFromSession();

    if (username != null) {
      // Memeriksa password saat ini dengan metode di DatabaseHelper
      bool isValid =
          await DatabaseHelper.instance.loginUser(username, currentPassword);
      return isValid;
    } else {
      // Tidak ada username dalam sesi, beri tahu pengguna
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Username tidak ditemukan dalam sesi."),
      ));
      return false;
    }
  }

  // Fungsi untuk menyimpan password baru
  Future<void> saveNewPassword() async {
    // Mengambil password baru dari controller
    String newPassword = newPasswordController.text;

    // Mengambil username dari sesi
    String? username = await getUsernameFromSession();

    if (username != null) {
      // Memeriksa apakah password saat ini benar
      bool isCurrentValid = await isCurrentPasswordValid();

      if (isCurrentValid) {
        // Memeriksa apakah newPassword tidak kosong
        if (newPassword.isNotEmpty) {
          // Jika password saat ini benar dan newPassword tidak kosong, simpan password baru
          await DatabaseHelper.instance.changePassword(username, newPassword);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Password berhasil diubah."),
          ));

          // Mengosongkan formulir setelah berhasil menyimpan
          newPasswordController.clear();
          currentPasswordController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Password baru tidak boleh kosong."),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password saat ini salah. Password tidak diubah."),
        ));
      }
    } else {
      // Tidak ada username dalam sesi, beri tahu pengguna
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Username tidak ditemukan dalam sesi."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String developerName = "Hosnol Arifin";
    String developerNIM = "1941720045";
    String tanggal = "28 September 2023";

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: SingleChildScrollView( // Gunakan SingleChildScrollView di sini
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ganti Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password Saat Ini'),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password Baru'),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                // Mengatur lebar tombol sesuai lebar perangkat
                child: ElevatedButton(
                  onPressed: () {
                    saveNewPassword();
                  },
                  child: Text('SIMPAN'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Lebar kotak ikon
                    height: 100, // Tinggi kotak ikon
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ), // Garis pinggir kotak
                    ),
                    child: Center(
                      child: Icon(
                        Icons.account_circle, // Ikon profil
                        size: 64, // Ukuran ikon
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Memberikan jarak antara kotak ikon dan teks
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABOUT THIS APP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Aplikasi ini dibuat oleh', style: TextStyle(fontSize: 16)),
                      Text('Nama : $developerName', style: TextStyle(fontSize: 16)),
                      Text('NIM  : $developerNIM', style: TextStyle(fontSize: 16)),
                      Text('Tanggal : $tanggal', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20), // Beri jarak bawah untuk menghindari tumpang tindih dengan keyboard
            ],
          ),
        ),
      ),
    );
  }
}
