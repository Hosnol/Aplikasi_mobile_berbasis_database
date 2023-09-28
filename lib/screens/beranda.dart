import 'package:aplikasi_berbasis_database/screens/DetailCashFlow.dart';
import 'package:aplikasi_berbasis_database/screens/TambahPemasukan.dart';
import 'package:aplikasi_berbasis_database/screens/TambahPengeluaran.dart';
import 'package:aplikasi_berbasis_database/screens/pengaturan.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aplikasi_berbasis_database/database/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class beranda extends StatefulWidget {
  @override
  _berandaState createState() => _berandaState();
}

class _berandaState extends State<beranda> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  double totalPemasukan = 0.0;
  double totalPengeluaran = 0.0;
  List<FlSpot> pemasukanSpots = [];
  List<FlSpot> pengeluaranSpots = [];

  @override
  void initState() {
    super.initState();
    _ambilTotalPemasukan();
    _ambilTotalPengeluaran();
  }

  Future<void> _ambilTotalPemasukan() async {
    double total = await databaseHelper.getTotalPemasukan();
    setState(() {
      totalPemasukan = total;
    });
  }

  Future<void> _updateTotalPemasukan() async {
    double total = await databaseHelper.getTotalPemasukan();
    setState(() {
      totalPemasukan = total;
    });

    // Ambil data pemasukan dari database
    List<Map<String, dynamic>> pemasukan =
        await databaseHelper.getPemasukanData();

    // Update grafik pemasukan dengan data dari database
    _updateGrafikPemasukan(pemasukan);
  }

  void _updateGrafikPemasukan(List<Map<String, dynamic>> pemasukan) async {
    List<FlSpot> spots = [];
    int indeks = 0; // Mulai indeks dari 0

    // Loop melalui data pemasukan dan tambahkan ke spots
    for (var data in pemasukan) {
      double nominal = data['nominal'] as double;
      spots.add(FlSpot(indeks.toDouble(), nominal));
      indeks++; // Tambahkan indeks setelah menambahkan data
    }

    // Perbarui pemasukanSpots pada grafik
    setState(() {
      pemasukanSpots = spots;
    });
  }

  // Mengambil total pengeluaran
  Future<void> _ambilTotalPengeluaran() async {
    double total = await databaseHelper.getTotalPengeluaran();
    setState(() {
      totalPengeluaran = total;
    });
  }

  // Mengupdate total pengeluaran
  Future<void> _updateTotalPengeluaran() async {
    double total = await databaseHelper.getTotalPengeluaran();
    setState(() {
      totalPengeluaran = total;
    });

    // Ambil data pengeluaran dari database
    List<Map<String, dynamic>> pengeluaran = await databaseHelper.getPengeluaranData();

    // Update grafik pengeluaran dengan data dari database
    _updateGrafikPengeluaran(pengeluaran);
  }

  // Ploting untuk grafik
  void _updateGrafikPengeluaran(List<Map<String, dynamic>> pengeluaran) async {
    List<FlSpot> spots = [];
    int indeks = 0; // Mulai indeks dari 0

    // Loop melalui data pengeluaran dan tambahkan ke spots
    for (var data in pengeluaran) {
      double nominal = data['nominal'] as double;
      spots.add(FlSpot(indeks.toDouble(), nominal));
      indeks++; // Tambahkan indeks setelah menambahkan data
    }

    // Perbarui pengeluaranSpots pada grafik
    setState(() {
      pengeluaranSpots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rupiahFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final formattedTotalPemasukan = rupiahFormat.format(totalPemasukan);
    final formattedTotalPengeluaran = rupiahFormat.format(totalPengeluaran);

    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Rangkuman Bulan Ini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Pengeluaran:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              formattedTotalPengeluaran,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Pemasukan:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              formattedTotalPemasukan,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Grafik Pemasukan dan Pengeluaran per Hari:',
              style: TextStyle(fontSize: 16.0),
            ),
            Container(
              height: 150.0, // Sesuaikan tinggi grafik sesuai kebutuhan
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: pemasukanSpots.length.toDouble() - 1,
                  minY: 0,
                  maxY: totalPemasukan,
                  lineBarsData: [
                    LineChartBarData(
                      spots: pemasukanSpots,
                      isCurved: true,
                      colors: [Colors.green],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: pengeluaranSpots,
                      isCurved: true,
                      colors: [Colors.red],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              shrinkWrap: true,
              children: [
                _buildMenuCard(
                  icon: 'assets/add_income.svg',
                  label: 'Tambah Pemasukan',
                  onTap: () async {
                    // Navigasi ke halaman "Tambah Pemasukan"
                    bool pemasukanDitambahkan = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahPemasukan(databaseHelper),
                        ));
                    // Jika pemasukan ditambahkan, perbarui total pemasukan
                    if (pemasukanDitambahkan == true) {
                      _updateTotalPemasukan();
                    }
                  },
                ),
                _buildMenuCard(
                  icon: 'assets/add_expense.svg',
                  label: 'Tambah Pengeluaran',
                  onTap: () async {
                    // Navigasi ke halaman "Tambah Pemasukan"
                    bool pengeluaranDitambahkan = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TambahPengeluaran(databaseHelper),
                        ));
                    // Jika pemasukan ditambahkan, perbarui total pemasukan
                    if (pengeluaranDitambahkan == true) {
                      _updateTotalPengeluaran();
                    }
                  },
                ),
                _buildMenuCard(
                  icon: 'assets/cash_flow.svg',
                  label: 'Detail Cash Flow',
                  onTap: () {
                    // Navigasi ke halaman "Detail Cash Flow"
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailCashFlow()));
                  },
                ),
                _buildMenuCard(
                  icon: 'assets/settings.svg',
                  label: 'Pengaturan',
                  onTap: () {
                    // Navigasi ke halaman "Pengaturan"
                    Navigator.push(context, MaterialPageRoute(builder: (context) => pengaturan()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      {required String icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                width: 80.0,
                height: 80.0,
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
