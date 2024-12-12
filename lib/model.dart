class Food {
  final String name;
  final String description;
  final String imageUrl;  // Add a field for food image
  int availableQuantity;

  Food({
    required this.name, 
    required this.description, 
    required this.imageUrl,  // Include the image URL in the constructor
    required this.availableQuantity
  });
}

class Country {
  final String name;
  final String imageUrl;  // Add a field for country image
  final List<Food> foods;

  Country({
    required this.name, 
    required this.imageUrl,  // Include the image URL in the constructor
    required this.foods
  });
}
