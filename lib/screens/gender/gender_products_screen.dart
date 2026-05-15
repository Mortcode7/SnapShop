import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapshop/models/products.dart';
import 'package:snapshop/screens/details/details_screen.dart';
import 'dart:convert';

import '../../../components/product_card.dart';

class GenderProductsScreen extends StatelessWidget {
  final String gender;

  const GenderProductsScreen({Key? key, required this.gender}) : super(key: key);

  Future<List<Product>> _fetchProductsByGender() async {
    final response = await http.get(Uri.parse('http://192.168.1.5/get_products_by_gender.php?gender=$gender'));

    if (response.statusCode == 200) {
      final List<dynamic> productJson = jsonDecode(response.body);
      return productJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$gender Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _fetchProductsByGender(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProductCard(
                    product: product,
                    onPress: () => Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments: ProductDetailsArguments(product: product),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
