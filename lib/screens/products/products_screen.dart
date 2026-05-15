import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapshop/components/product_card.dart';
import 'package:snapshop/models/products.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://192.168.1.5/get_products.php'));
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      setState(() {
        products = productsJson.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    product: products[index],
                    onPress: () => Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                    arguments: ProductDetailsArguments(product: products[index]),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
