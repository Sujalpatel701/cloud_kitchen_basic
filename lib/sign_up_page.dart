import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui'; // For ImageFilter

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  Future<void> _signUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username must be at least 6 characters long')),
      );
      return;
    }

    if (password.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters long')),
      );
      return;
    }

    if (!password.split('').any(
        (char) => char.toUpperCase() == char && char.toLowerCase() != char)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must contain at least 1 uppercase letter')),
      );
      return;
    }

    if (username.isNotEmpty && password.isNotEmpty) {
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      setState(() {
        _message = 'Account created successfully!';
      });
      Navigator.pop(context);
    } else {
      setState(() {
        _message = 'Please enter both username and password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(
        children: [
          // Background image with blur effect
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup.jpeg'), // Add your image asset here
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
          // Sign Up form with circular image and text
          _buildSignUpForm(),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
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
            onPressed: _signUp,
            child: const Text('Sign Up'),
          ),
          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _message,
                style: TextStyle(
                    color: _message.contains('success')
                        ? Colors.green
                        : Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
