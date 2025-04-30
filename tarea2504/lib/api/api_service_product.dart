
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiServiceProduct {
  final String baseUrl = 'https://api.restful-api.dev/objects';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    return Product.fromJson(jsonDecode(response.body));
  }

  Future<void> updateProduct(String id, Product product) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
  }

  Future<void> deleteProduct(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
