import 'package:aplikasi_berbasis_database/screens/beranda.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_berbasis_database/database/DatabaseHelper.dart';
import 'package:aplikasi_berbasis_database/session/session_utils.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordObscure = true; // Untuk mengontrol apakah teks kata sandi harus disembunyikan
  bool _isPasswordFilled = false; // Untuk mengontrol apakah field kata sandi sudah diisi

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My CashBook'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.0),
                Text(
                  'Selamat Datang di',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Image.asset(
                  "assets/images/cashbook-logo.png",
                  width: 250.0,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isPasswordObscure,
                    onChanged: (value) {
                      setState(() {
                        // Tampilkan tombol "Lihat Password" hanya jika field kata sandi diisi
                        _isPasswordFilled = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.vpn_key),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                      suffixIcon: _isPasswordFilled
                          ? IconButton(
                        icon: Icon(_isPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscure = !_isPasswordObscure;
                          });
                        },
                      )
                          : null, // Tambahkan null jika field kata sandi kosong
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // Validasi input
                      final username = _usernameController.text;
                      final password = _passwordController.text;

                      if (username.isNotEmpty && password.isNotEmpty) {
                        // Proses login
                        bool loggedIn = await DatabaseHelper.instance.loginUser(username, password);

                        if (loggedIn) {
                          // Login berhasil, simpan username dalam sesi
                          await saveUsernameInSession(username);

                          // Login berhasil, arahkan ke halaman lain
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => beranda(),
                            ),
                          );
                        } else {
                          // Login gagal, tampilkan pesan kesalahan
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Login Gagal'),
                                content: Text('Nama pengguna atau kata sandi salah.'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        // Tampilkan pesan jika ada field yang kosong
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Peringatan'),
                              content: Text('Harap isi semua field.'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                Text(
                  'My CashBook V1.0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
