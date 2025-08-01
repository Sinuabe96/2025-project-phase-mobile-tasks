import '../models/product_model.dart';

abstract class RemoteDataSource {
  /// Fetches all products from the remote API
  Future<List<ProductModel>> getAllProducts();
  
  /// Fetches a specific product by ID from the remote API
  Future<ProductModel?> getProductById(String id);
  
  /// Creates a new product on the remote API
  Future<void> createProduct(ProductModel product);
  
  /// Updates an existing product on the remote API
  Future<void> updateProduct(ProductModel product);
  
  /// Deletes a product from the remote API
  Future<void> deleteProduct(String id);
} 