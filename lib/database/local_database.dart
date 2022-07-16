import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yazar_temmuz/model/book.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();

  static final LocalDatabase _obj = LocalDatabase._privateConstructor();

  factory LocalDatabase() {
    return _obj;
  }

  Database? _database;

  Future<Database?> _getDatabase() async {
    if (_database == null) {
      String folderPath = await getDatabasesPath();
      String databasePath = join(folderPath, "yazar_temmuz.db");
      _database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: _createTable,
      );
    }
    return _database;
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE "kitaplar" (
	        "id"	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
	        "name"	TEXT NOT NULL,
	        "createdDate"	INTEGER
        );
      ''',
    );
  }

  Future<int> createBook(Book? book) async {
    Database? db = await _getDatabase();

    return 0;
  }
}
