import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_berbasis_database/database/DatabaseHelper.dart';

class DetailCashFlow extends StatefulWidget {
  @override
  _DetailCashFlowState createState() => _DetailCashFlowState();
}

class _DetailCashFlowState extends State<DetailCashFlow> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _pemasukanData = [];
  List<Map<String, dynamic>> _pengeluaranData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final pemasukanData = await databaseHelper.getPemasukanData();
    final pengeluaranData = await databaseHelper.getPengeluaranData();

    setState(() {
      _pemasukanData = pemasukanData;
      _pengeluaranData = pengeluaranData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggabungkan pemasukan dan pengeluaran dalam satu list
    final List<Map<String, dynamic>> _cashFlowData = []
      ..addAll(_pemasukanData)
      ..addAll(_pengeluaranData);

    // Mengurutkan data berdasarkan tanggal
    _cashFlowData.sort((a, b) {
      final DateTime tanggalA = DateFormat('dd/MM/yyyy').parse(a['tanggal']);
      final DateTime tanggalB = DateFormat('dd/MM/yyyy').parse(b['tanggal']);
      return tanggalB.compareTo(tanggalA);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cash Flow'),
      ),
      body: ListView.separated(
        itemCount: _cashFlowData.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _cashFlowData[index];
          final nominal = item['nominal'] as double;
          final tanggal = item['tanggal'] as String;
          final keterangan = item['keterangan'] as String;
          final rupiahFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

          final bool isPemasukan = item['jenis'] == 'pemasukan';
          final IconData iconData = isPemasukan ? Icons.arrow_back : Icons.arrow_forward;
          final Color iconColor = isPemasukan ? Colors.green : Colors.red;
          final String jenis = isPemasukan ? '[ + ]' : '[ - ]';

          return Column(
            children: [
              ListTile(
                title: Text(
                  '$jenis ${rupiahFormat.format(nominal)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.0),
                    Text('$keterangan', style: TextStyle(color: Colors.black),),
                    SizedBox(height: 8.0),
                    Text('$tanggal'),
                  ],
                ),
                trailing: Icon(
                  iconData,
                  color: iconColor,
                  size: 50.0,
                ),
              ),
              Divider(
                color: Colors.black38, // Ubah warna garis sesuai kebutuhan
                thickness: 1.0, // Ubah ketebalan garis sesuai kebutuhan
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox.shrink(); // Hilangkan pemisah bawaan
        },
      ),
    );
  }
}
