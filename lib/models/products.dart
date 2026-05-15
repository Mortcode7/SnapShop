class Product {
  final int id;
  final String name;
  final String brand;
  final String description;
  final String image;
  final String gender;
  final double price;
  final int userId;
  final String category;
  final bool isFavourite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.image,
    required this.gender,
    required this.price,
    required this.userId,
    required this.category,
    this.isFavourite = false,
  });

 factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] is String ? int.parse(json['id']) : json['id'],
    name: json['name'],
    brand: json['brand'],
    description: json['description'],
    image: json['image'],
    gender: json['gender'],
    category: json['category'] ?? '',
    price: (json['price'] is String) ? double.parse(json['price']) : json['price'].toDouble(),
    userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
  );
}

}
