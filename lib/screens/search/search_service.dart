import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchService {
  static Future<List<dynamic>> searchProducts(String query) async {
    final response = await http.get(Uri.parse("http://192.168.1.5/search_products.php?query=$query"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load products");
    }
  }
}
