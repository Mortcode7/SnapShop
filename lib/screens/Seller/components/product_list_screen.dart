import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../globals.dart' as globals;
import 'product_edit_screen.dart';
import 'package:snapshop/constants.dart';
class ProductListScreen extends StatefulWidget {
  static const String routeName = "/product_list";

  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<dynamic>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.5/get_products_seller.php?user_id=${globals.userId}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.5/delete_product.php'),
      body: {'id': productId.toString()},
    );

    if (response.statusCode == 200) {
      print('Delete response: ${response.body}');
      setState(() {
        productsFuture = fetchProducts();
      });
    } else {
      print('Failed to delete product: ${response.statusCode}');
      throw Exception('Failed to delete product');
    }
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Delete Product',
            style: TextStyle(color: Colors.orange),
          ),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: kPrimaryColor,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final List<String> imageUrls = product['image'].split(',');

                // Ensure the product ID is parsed as an integer
                final int productId = int.tryParse(product['id'].toString()) ?? -1;

                return Dismissible(
                  key: Key(productId.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final bool? confirmed = await showDeleteConfirmationDialog(context);
                    if (confirmed == true && productId != -1) {
                      await deleteProduct(productId);
                      return true;
                    } else {
                      return false;
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      'http://192.168.1.5/${imageUrls.first.trim()}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['name']),
                    subtitle: Text(product['description']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductEditScreen(product: product),
                        ),
                      );
                    },
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
