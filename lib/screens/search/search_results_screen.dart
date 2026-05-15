// search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:snapshop/models/products.dart';
import 'package:snapshop/screens/details/details_screen.dart';
import 'search_service.dart';
// Import the Product class

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<dynamic>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = SearchService.searchProducts(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products found"));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data![index];
                final product = Product.fromJson(productData); // Convert product data to Product instance
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    DetailsScreen.routeName,
                    arguments: ProductDetailsArguments(product: product),
                  ),
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            product.image.split(',')[0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                        ),
                        Text(product.name),
                        Text('${product.price} DA'),
                      ],
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
