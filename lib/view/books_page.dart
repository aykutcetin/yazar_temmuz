import 'package:flutter/material.dart';
import 'package:yazar_temmuz/database/local_database.dart';
import 'package:yazar_temmuz/model/book.dart';

class BooksPage extends StatefulWidget {
  BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final LocalDatabase database = LocalDatabase();

  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    database.readAllBooks().then((List<Book> allBooks) {
      setState(() {
        _books = allBooks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ana Sayfa",
        ),
        backgroundColor: Colors.purple,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(
          Icons.add,
          color: Colors.yellow,
        ),
        onPressed: () {
          _openDialog(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: Text(_books[index].name),
      subtitle: Text(_books[index].createdDate.toString()),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController bookController = TextEditingController();
        return AlertDialog(
          title: Text("Kitap Ekle"),
          content: TextField(
            controller: bookController,
            decoration: InputDecoration(
              hintText: "Kitap adını giriniz",
            ),
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Onayla"),
              onPressed: () async {
                String bookName = bookController.text.trim();
                if (bookName.isNotEmpty) {
                  Book book = Book(bookName, DateTime.now());
                  int bookId = await database.createBook(book);
                  print("Book Id: $bookId");
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
