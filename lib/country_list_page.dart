import 'package:flutter/material.dart';
import 'user_profile_page.dart';
import 'food_list_page.dart';
import 'model.dart';
import 'dart:ui'; // For using BackdropFilter

// Sample data with descriptions and images
final List<Country> countries = [
  Country(
  name: 'India',
  imageUrl: 'assets/india.jpg', // Example flag image for India
  foods: [
    Food(
      name: 'Biryani', 
      description: 'A flavorful rice dish cooked with spices, meat or vegetables.',
      imageUrl: 'assets/biryani.jpg', // Example food image for Biryani
      availableQuantity: 12
    ),
    Food(
      name: 'Chole Bhature', 
      description: 'A popular North Indian dish consisting of spicy chickpeas and deep-fried bread.',
      imageUrl: 'assets/chole.webp', // Example food image for Chole Bhature
      availableQuantity: 7
    ),
    Food(
      name: 'Dosa', 
      description: 'A thin, crispy pancake made from fermented rice batter, served with chutney and sambar.',
      imageUrl: 'assets/dosa.jpg', // Example food image for Dosa
      availableQuantity: 10
    ),
  ]
),

  Country(
    name: 'Italy',
    imageUrl: 'assets/italy.jpg', // Example flag image
    foods: [
      Food(
        name: 'Pizza', 
        description: 'A savory dish with cheese, tomatoes, and various toppings.',
        imageUrl: 'assets/pizza.webp', 
        availableQuantity: 10
      ),
      Food(
        name: 'Pasta', 
        description: 'An Italian cuisine made from wheat and served with sauce.',
        imageUrl: 'assets/pasta.webp',
        availableQuantity: 5
      ),
    ]
  ),
  Country(
    name: 'Japan',
    imageUrl: 'assets/japan.jpg', // Example flag image
    foods: [
      Food(
        name: 'Sushi', 
        description: 'A dish with vinegared rice, seafood, and vegetables.',
        imageUrl: 'assets/sushi.webp', 
        availableQuantity: 8
      ),
      Food(
        name: 'Ramen', 
        description: 'A Japanese noodle soup with meat or vegetables.',
        imageUrl: 'assets/ramen.webp',
        availableQuantity: 4
      ),
    ]
  ),
  // Add more countries and foods as needed
];

class CountryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Countries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background blur image
          Positioned.fill(
            child: Image.asset(
              'assets/countryback.jpg', // Add your background image here
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6), // Apply a dark overlay
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(),
              ),
            ),
          ),
          // Main content
          ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0), // Add vertical space between list items
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(countries[index].imageUrl), // Country flag
                  ),
                  title: Text(
                    countries[index].name,
                    style: const TextStyle(color: Colors.white), // White text on dark background
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodListPage(country: countries[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
