class Product {
  final String name;
  final String price;
  final String imageAsset;
  final rating;
  Product(
    this.name,
    this.price,
    this.imageAsset,
    this.rating,
  );

  // Add a factory method to create a Product from a map (for loading from SharedPreferences)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      map['name'],
      map['price'],
      map['imageAsset'],
      map['rating'],
    );
  }

  // Convert a Product to a map (for saving to SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageAsset': imageAsset,
      'rating': rating
    };
  }
}
