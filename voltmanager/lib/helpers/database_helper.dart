import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE my_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            valu TEXT NOT NULL,
            type TEXT NOT NULL,
            quanty INTEGER NOT NULL

          )
        ''');
      },
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('my_table', row);
  }

  Future<List<Map<String, dynamic>>> fetchAllRows() async {
    Database? db = await database;
    return await db!.query('my_table');
  }
}
