// CartItem.dart

class CartItem {
  final int id;
  final String name;
  final String brand;
  final String description;
  final String image; // Store only the first image URL
  final String gender;
  final String price;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.image,
    required this.gender,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    String firstImageUrl = json['image'].split(',')[0]; // Get the first image URL
    return CartItem(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      description: json['description'],
      image: firstImageUrl,
      gender: json['gender'],
      price: json['price'].toString(),
    );
  }
}
