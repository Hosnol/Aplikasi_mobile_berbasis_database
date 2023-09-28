import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'cashbook.db';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createCashTable,
    );
  }

  Future<void> _createCashTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pemasukan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nominal REAL,
        keterangan TEXT,
        tanggal TEXT,
        jenis TEXT
      )
    ''');
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> users = await db!.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );

    return users.isNotEmpty;
  }

  Future<void> changePassword(String username, String newPassword) async {
    final db = await instance.database;
    await db?.update(
      'users',
      {'password': newPassword},
      where: "username = ?",
      whereArgs: [username],
    );
  }

  Future<void> addCash(
      double nominal, String keterangan, String tanggal, String jenis) async {
    final db = await instance.database;
    await db?.insert(
      'cash',
      {
        'nominal': nominal,
        'keterangan': keterangan,
        'tanggal': tanggal,
        'jenis': jenis
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double> getTotalPemasukan() async {
    final db = await instance.database;
    final result = await db?.rawQuery(
        'SELECT SUM(nominal * 1.0) AS total FROM cash WHERE jenis = ?',
        ['pemasukan']);
    double total =
        (result?[0]['total'] as double?) ?? 0.0; // Ubah hasil ke double
    return total;
  }

  Future<List<Map<String, dynamic>>> getPemasukanData() async {
    final db = await instance.database;
    return await db!.query('cash',
        where: 'jenis =?',
        whereArgs: ['pemasukan']);
  }

  Future<double> getTotalPengeluaran() async {
    final db = await instance.database;
    final result = await db?.rawQuery(
        'SELECT SUM(nominal * 1.0) AS total FROM cash WHERE jenis = ?',
        ['pengeluaran']); // Ubah ke double
    double total =
        (result?[0]['total'] as double?) ?? 0.0; // Ubah hasil ke double
    return total;
  }

  Future<List<Map<String, dynamic>>> getPengeluaranData() async {
    final db = await instance.database;
    return await db!.query('cash',
        where: 'jenis = ?',
        whereArgs: ['pengeluaran']);
  }
}
