import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class beranda extends StatefulWidget {
  @override
  _berandaState createState() => _berandaState();
}

class _berandaState extends State<beranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My CashBook'),
      ),
      body: Padding(
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
              'Rp 1,500,000', // Gantilah dengan nilai aktual
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
              'Rp 2,000,000', // Gantilah dengan nilai aktual
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
                  maxX: 6, // Sesuaikan dengan jumlah data Anda
                  minY: 0,
                  maxY: 2500000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2000000),
                        FlSpot(1, 1800000),
                        FlSpot(2, 2200000),
                        FlSpot(3, 2100000),
                        FlSpot(4, 2400000),
                        FlSpot(5, 2300000),
                        FlSpot(6, 2500000),
                      ],
                      isCurved: true,
                      colors: [Colors.green],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/add_income.svg',
                              width: 64.0,
                              height: 64.0,
                            ),
                            Text('Tambah Pemasukan'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Menu 2 (SVG)
                  Card(
                    child: InkWell(
                      onTap: () {
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/add_expense.svg',
                              width: 64.0,
                              height: 64.0,
                            ),
                            Text('Tambah Pengeluaran'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/cash_flow.svg',
                              width: 64.0,
                              height: 64.0,
                            ),
                            Text('Detail Cash Flow'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/settings.svg',
                              width: 64.0,
                              height: 64.0,
                            ),
                            Text('Pengaturan'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
