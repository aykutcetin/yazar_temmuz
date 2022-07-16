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

  final String _booksTableName = "kitaplar";
  final String _booksId = "id";
  final String _booksName = "name";
  final String _booksCreatedDate = "createdDate";

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
        CREATE TABLE $_booksTableName" (
	        $_booksId	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
	        $_booksName	TEXT NOT NULL,
	        $_booksCreatedDate	INTEGER
        );
      ''',
    );
  }

  Future<int> createBook(Book book) async {
    Database? db = await _getDatabase();
    if (db != null) {
      return await db.insert(
        _booksTableName,
        book.toMap(),
      );
    }
    return -1;
  }

  Future<List<Book>> readAllBooks() async {
    List<Book> result = [];
    Database? db = await _getDatabase();
    if (db != null) {
      List<Map<String, dynamic>> booksMapList = await db.query(_booksTableName);
      for (Map<String, dynamic> bookMap in booksMapList) {
        Book book = Book.fromMap(bookMap);
        result.add(book);
      }
    }
    return result;
  }

  Future<int> updateBook(Book book) async {
    Database? db = await _getDatabase();
    if (db != null) {
      return await db.update(
        _booksTableName,
        book.toMap(),
        where: "$_booksId = ?",
        whereArgs: [book.id],
      );
    } else {
      return 0;
    }
  }

  Future<int> deleteBook(Book book) async{
    Database? db = await _getDatabase();
    if (db != null) {
      return await db.delete(
        _booksTableName,
        where: "$_booksId = ?",
        whereArgs: [book.id],
      );
    } else {
      return 0;
    }
  }
}
