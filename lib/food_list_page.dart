import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';
import 'dart:ui'; // For BackdropFilter
import 'food_detail_page.dart'; // Import FoodDetailPage

class FoodListPage extends StatefulWidget {
  final Country country;

  const FoodListPage({Key? key, required this.country}) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.country.name} Foods'),
      ),
      body: Stack(
        children: [
          // Background image with blur
          Positioned.fill(
            child: Image.asset(
              'assets/listback.jpg', // Your background image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6), // Dark overlay
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(),
              ),
            ),
          ),
          // Main content
          ListView.builder(
            itemCount: widget.country.foods.length,
            itemBuilder: (context, index) {
              Food food = widget.country.foods[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0), // Vertical space
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(food.imageUrl), // Food image
                  ),
                  title: Text(
                    food.name,
                    style: const TextStyle(color: Colors.white), // White text
                  ),
                  subtitle: Text(
                    'Available: ${food.availableQuantity}',
                    style: const TextStyle(color: Colors.white70), // White text
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: food.availableQuantity > 0 ? Colors.blue : Colors.red,
                    ),
                    onPressed: food.availableQuantity > 0
                        ? () {
                            _orderFood(context, food);
                          }
                        : null,
                    child: const Text('Order'),
                  ),
                  onTap: () {
                    _showFoodDetails(context, food);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _orderFood(BuildContext context, Food food) async {
    if (food.availableQuantity > 0) {
      setState(() {
        food.availableQuantity--; // Update the available quantity
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> orders = prefs.getStringList('orders') ?? [];

      int index = orders.indexWhere((order) => order.startsWith('${widget.country.name}|${food.name}'));
      if (index != -1) {
        List<String> parts = orders[index].split('|');
        int quantity = int.parse(parts[2]) + 1; // Increase quantity
        orders[index] = '${parts[0]}|${parts[1]}|$quantity'; // Update the order
      } else {
        orders.add('${widget.country.name}|${food.name}|1'); // New order with quantity 1
      }

      await prefs.setStringList('orders', orders);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food Ordered Successfully')),
      );
    }
  }

  void _showFoodDetails(BuildContext context, Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(food: food),
      ),
    );
  }
}
