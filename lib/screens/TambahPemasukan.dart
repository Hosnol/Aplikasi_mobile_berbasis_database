import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_berbasis_database/database/DatabaseHelper.dart';

class TambahPemasukan extends StatefulWidget {
  final DatabaseHelper database;

  TambahPemasukan(this.database);

  @override
  _TambahPemasukanState createState() => _TambahPemasukanState();
}

class _TambahPemasukanState extends State<TambahPemasukan> {
  TextEditingController _tanggalController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  TextEditingController _nominalController = TextEditingController();
  TextEditingController _keteranganController = TextEditingController();

  DateTime _selectedDate = DateTime.now(); // Tanggal default adalah hari ini

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        )) ??
        _selectedDate; // Menggunakan _selectedDate jika picked adalah null

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Fungsi untuk mereset input
  void _resetInput() {
    setState(() {
      // _tanggalController.text =
      //     DateFormat('dd/MM/yyyy').format(DateTime(2021, 1, 1));
      _tanggalController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      _nominalController.text = '';
      _keteranganController.text = '';
    });
  }

  // Fungsi untuk menyimpan data pemasukan ke database
  Future<void> _savePemasukan() async {
    final tanggal = _tanggalController.text;
    final nominal = double.tryParse(_nominalController.text) ?? 0.0;
    final keterangan = _keteranganController.text;
    final jenis = 'pemasukan' ;

    // Validasi data sebelum menyimpan
    if (tanggal.isEmpty || nominal <= 0.0) {
      // Tampilkan pesan kesalahan jika data tidak valid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Kesalahan'),
          content: Text('Mohon isi tanggal dan nominal dengan benar.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    // simpan di database
    await widget.database.addCash(nominal, keterangan, tanggal, jenis);

    // Kembali ke halaman "Beranda"
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pemasukan')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _tanggalController,
              onTap: () {
                // Tampilkan date picker saat field tanggal di-tap
                _selectDate(context);
              },
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: InkWell(
                  onTap: () {
                    // Tampilkan date picker saat ikon kalender di-tap
                    _selectDate(context);
                  },
                  child: Icon(Icons
                      .calendar_today), // Ganti dengan ikon kalender yang sesuai
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nominal',
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              // Memungkinkan input hanya angka
              decoration: InputDecoration(
                hintText: 'Masukkan nominal pemasukan',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Keterangan',
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: _keteranganController,
              decoration: InputDecoration(
                hintText: 'Tambahkan keterangan (opsional)',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _resetInput,
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: Text(
                    'RESET',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _savePemasukan,
                  style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                  child: Text(
                    'SIMPAN',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
