import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapshop/components/product_card.dart';
import 'package:snapshop/models/products.dart';
import 'package:snapshop/screens/details/details_screen.dart';
import 'package:snapshop/screens/products/products_screen.dart';
import 'dart:convert';

import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "Popular Products",
                  press: () {
                    Navigator.pushNamed(context, ProductsScreen.routeName);
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.map((product) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ProductCard(
                        product: product,
                        onPress: () => Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments: ProductDetailsArguments(product: product),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else {
          return Text('No products available');
        }
      },
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.5/get_products.php'));
  if (response.statusCode == 200) {
    final List<dynamic> productsJson = jsonDecode(response.body);
    return productsJson.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch products');
  }
}



// import 'package:flutter/material.dart';

// import '../../../components/product_card.dart';
// import '../../../models/Products.dart';
// import '../../details/details_screen.dart';
// import '../../products/products_screen.dart';
// import 'section_title.dart';

// class PopularProducts extends StatelessWidget {
//   const PopularProducts({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SectionTitle(
//             title: "Popular Products",
//             press: () {
//               Navigator.pushNamed(context, ProductsScreen.routeName);
//             },
//           ),
          
//         ),

        

//         // SingleChildScrollView(
//         //   scrollDirection: Axis.horizontal,
//         //   child: Row(
//         //     children: [
//         //       ...List.generate(
//         //         demoProducts.length,
//         //         (index) {
//         //           if (demoProducts[index].isPopular) {
//         //             return Padding(
//         //               padding: const EdgeInsets.only(left: 20),
//         //               child: ProductCard(
//         //                 product: demoProducts[index],
//         //                 onPress: () => Navigator.pushNamed(
//         //                   context,
//         //                   DetailsScreen.routeName,
//         //                   arguments: ProductDetailsArguments(
//         //                       product: demoProducts[index]),
//         //                 ),
//         //               ),
//         //             );
//         //           }

//         //           return const SizedBox
//         //               .shrink(); // here by default width and height is 0
//         //         },
//         //       ),
//         //       const SizedBox(width: 20),
//         //     ],
//         //   ),
//         // )

//       ],
//     );
//   }
// }
