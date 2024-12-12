import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model.dart'; 
import 'dart:ui'; 


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String username = '';
  Map<String, int> orderSummary = {}; // Changed to a map to count quantities

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';

      // Fetch actual orders from SharedPreferences
      List<String> orders = prefs.getStringList('orders') ?? [];
      
      // Process orders to count quantities
      orderSummary.clear();
      for (var order in orders) {
        List<String> parts = order.split('|');
        String foodName = parts[1];
        int quantity = parts.length > 2 ? int.parse(parts[2]) : 1;

        if (orderSummary.containsKey(foodName)) {
          orderSummary[foodName] = orderSummary[foodName]! + quantity; // Increment quantity
        } else {
          orderSummary[foodName] = quantity; // Initialize quantity
        }
      }
    });
  }

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logout', true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with blur effect
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/userback.jpg'), // Use your own background image
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.2), // Adds a slight color overlay
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make the scaffold transparent to see the background
          appBar: AppBar(
            title: const Text('User Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _signOut,
              ),
            ],
            backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent app bar
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome, $username!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Semi-transparent container background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: orderSummary.isEmpty
                      ? const Center(child: Text('No orders yet.', style: TextStyle(fontSize: 18)))
                      : ListView.builder(
                          itemCount: orderSummary.length,
                          itemBuilder: (context, index) {
                            String foodName = orderSummary.keys.elementAt(index);
                            int quantity = orderSummary[foodName]!;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  foodName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Quantity: $quantity',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                leading: Icon(Icons.fastfood, color: Colors.blue[700]), // Food icon
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
