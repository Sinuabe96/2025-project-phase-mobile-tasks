import '../models/product_model.dart';

abstract class LocalDataSource {
  /// Retrieves all products from local storage
  Future<List<ProductModel>> getAllProducts();
  
  /// Retrieves a specific product by ID from local storage
  Future<ProductModel?> getProductById(String id);
  
  /// Stores a new product in local storage
  Future<void> createProduct(ProductModel product);
  
  /// Updates an existing product in local storage
  Future<void> updateProduct(ProductModel product);
  
  /// Deletes a product from local storage
  Future<void> deleteProduct(String id);
  
  /// Caches products from remote source to local storage
  Future<void> cacheProducts(List<ProductModel> products);
  
  /// Clears all cached products from local storage
  Future<void> clearCache();
} 