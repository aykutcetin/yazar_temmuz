import 'package:flutter/material.dart';
import 'package:yazar_temmuz/database/local_database.dart';

class BooksPage extends StatelessWidget {
  final LocalDatabase database = LocalDatabase();

  BooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    database.createBook(null);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ana Sayfa",
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
