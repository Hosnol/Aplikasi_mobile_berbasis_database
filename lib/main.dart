import 'package:aplikasi_berbasis_database/screens/LoginForm.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter sudah diinisialisasi

  // Buka database
  final database = openDatabase(
    join(await getDatabasesPath(), 'cashbook.db'),
    version: 1,
    onCreate: (db, version) async{
      await db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)",
      );
      await db.execute(
        "CREATE TABLE cash(id INTEGER PRIMARY KEY AUTOINCREMENT, nominal REAL, keterangan TEXT, tanggal TEXT, jenis TEXT)",
      );
    },
  );

  // Tambahkan pengguna langsung ke dalam database
  final db = await database;
  await db.insert(
    'users',
    {'username': 'hosnol', 'password': '12345678'},
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Cashbook V1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginForm(),
    );
  }
}