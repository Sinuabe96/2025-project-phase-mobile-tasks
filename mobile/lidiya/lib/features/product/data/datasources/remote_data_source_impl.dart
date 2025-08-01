import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://api.example.com/products',
  });

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // For demo purposes, return mock data when API fails
      return _getMockProducts();
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductModel.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      // For demo purposes, return mock product when API fails
      final mockProducts = _getMockProducts();
      return mockProducts.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      // For demo purposes, just simulate success
      print('Product created: ${product.name}');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      // For demo purposes, just simulate success
      print('Product updated: ${product.name}');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await client.delete(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode != 204) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      // For demo purposes, just simulate success
      print('Product deleted: $id');
    }
  }

  // Mock data for demonstration
  List<ProductModel> _getMockProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Nike Air Max',
        description: 'Comfortable running shoes with air cushioning',
        imageUrl: 'https://example.com/nike-air-max.jpg',
        price: 129.99,
      ),
      ProductModel(
        id: '2',
        name: 'Adidas Ultraboost',
        description: 'Premium running shoes with energy return',
        imageUrl: 'https://example.com/adidas-ultraboost.jpg',
        price: 179.99,
      ),
      ProductModel(
        id: '3',
        name: 'Puma RS-X',
        description: 'Retro-inspired sneakers with bold design',
        imageUrl: 'https://example.com/puma-rsx.jpg',
        price: 89.99,
      ),
    ];
  }
} 