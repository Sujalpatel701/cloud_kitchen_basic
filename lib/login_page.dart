import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up_page.dart';
import 'country_list_page.dart';
import 'dart:ui'; // Add this line

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggedIn = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logout') == true) {
      return;
    }
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (storedUsername != null && storedPassword != null) {
      setState(() {
        _isLoggedIn = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CountryListPage()),
      );
    }
  }

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (_usernameController.text == storedUsername &&
        _passwordController.text == storedPassword) {
      prefs.setBool('logout', false);
      setState(() {
        _isLoggedIn = true;
        _errorMessage = '';
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CountryListPage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          // Background image with blur effect
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.jpeg'), // Add your image asset here
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Login form with circular image and text
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular image at the top
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/logo.webp'), // Add your image asset here
          ),
          const SizedBox(height: 10),
          // Text below the image
          const Text(
            'Cloud Kitchen',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              filled: true,
              fillColor: Colors.white70, // White background for text field
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: Colors.white70, // White background for text field
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: const Text('Don\'t have an account? Sign Up'),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
