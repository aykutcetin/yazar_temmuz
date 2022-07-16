import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yazar_temmuz/database/local_database.dart';
import 'package:yazar_temmuz/view/books_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordController = TextEditingController();

  String? _currentPassword;

  @override
  void initState() {
    super.initState();
    _readPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.purple,
      title: Text(
        "Login Page",
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTitle(),
        SizedBox(height: 20),
        _buildTextField(),
        SizedBox(height: 20),
        _buildSaveButton(context),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      _currentPassword == null
          ? "Hoşgeldiniz!\nBir Şifre Belirleyin"
          : "Mevcut Şifrenizle\nGiriş Yapın",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: "Şifreyi giriniz",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
        child: Text(
          _currentPassword == null ? "Kaydet" : "Giriş Yap",
        ),
        onPressed: () {
          _savePassword(context);
        });
  }

  Future<void> _savePassword(BuildContext context) async {
    String password = _passwordController.text.trim();
    if (password.isNotEmpty) {
      if(_currentPassword==null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("sifre", password);
        _openBooksPage(context);
      } else {
        if(password == _currentPassword){
          _openBooksPage(context);
        } else {
          _showSnackBar(context, "Şifre yanlış");
        }
      }
    }
  }

  Future<void> _readPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPassword = prefs.getString("sifre");
    });
  }

  void _openBooksPage(BuildContext context) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (BuildContext context) {
        return BooksPage();
      },
    );
    Navigator.pushReplacement(context, pageRoute);
  }

  void _showSnackBar(BuildContext context, String text){
    SnackBar snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
