import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'local_data_source.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences prefs;
  static const String _productsKey = 'cached_products';
  static const String _productPrefix = 'product_';

  LocalDataSourceImpl({required this.prefs});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final productsJson = prefs.getStringList(_productsKey) ?? [];
      
      return productsJson
          .map((json) => ProductModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final productJson = prefs.getString('$_productPrefix$id');
      
      if (productJson != null) {
        return ProductModel.fromJson(jsonDecode(productJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      
      await prefs.setString(
        '$_productPrefix${product.id}',
        jsonEncode(product.toJson()),
      );
      
      final existingProducts = await getAllProducts();
      existingProducts.add(product);
      await _cacheProductsList(existingProducts);
    } catch (e) {
      throw Exception('Failed to create product locally');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
     
      await prefs.setString(
        '$_productPrefix${product.id}',
        jsonEncode(product.toJson()),
      );
      
      // Update cached products list
      final existingProducts = await getAllProducts();
      final index = existingProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        existingProducts[index] = product;
        await _cacheProductsList(existingProducts);
      }
    } catch (e) {
      throw Exception('Failed to update product locally');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      // Remove individual product
      await prefs.remove('$_productPrefix$id');
      
      // Update cached products list
      final existingProducts = await getAllProducts();
      existingProducts.removeWhere((product) => product.id == id);
      await _cacheProductsList(existingProducts);
    } catch (e) {
      throw Exception('Failed to delete product locally');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await _cacheProductsList(products);
      
      // Also cache individual products for quick access
      for (final product in products) {
        await prefs.setString(
          '$_productPrefix${product.id}',
          jsonEncode(product.toJson()),
        );
      }
    } catch (e) {
      throw Exception('Failed to cache products');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Clear cached products list
      await prefs.remove(_productsKey);
      
      // Clear all individual product entries
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_productPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      throw Exception('Failed to clear cache');
    }
  }

  Future<void> _cacheProductsList(List<ProductModel> products) async {
    final productsJson = products
        .map((product) => jsonEncode(product.toJson()))
        .toList();
    await prefs.setStringList(_productsKey, productsJson);
  }
} 