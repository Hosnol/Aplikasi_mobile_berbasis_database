import 'package:aplikasi_berbasis_database/screens/LoginForm.dart';
import 'package:aplikasi_berbasis_database/screens/beranda.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: beranda(),
    );
  }
}