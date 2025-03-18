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
            comp TEXT NOT NULL,
            type TEXT ,
            valu INTEGER NOT NULL,
            unit TEXT NOT NULL,
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

  // New Method: Check if a row exists with specific criteria
  Future<Map<String, dynamic>?> queryRowWhere(
    Map<String, dynamic> criteria,
  ) async {
    final db = await database;
    String whereClause = criteria.keys.map((key) => "$key = ?").join(" AND ");
    List<dynamic> whereArgs = criteria.values.toList();
    var result = await db!.query(
      'my_table',
      where: whereClause,
      whereArgs: whereArgs,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // New Method: Update an existing row
  Future<int> updateRow(Map<String, dynamic> row) async {
    final db = await database;
    return await db!.update(
      'my_table',
      row,
      where: "id = ?",
      whereArgs: [row['id']], // Ensure you're passing the row ID
    );
  }
}
