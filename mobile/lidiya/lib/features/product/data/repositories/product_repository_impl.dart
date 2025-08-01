import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      // First try to get from local cache
      final localProducts = await localDataSource.getAllProducts();
      
      if (localProducts.isNotEmpty) {
        return localProducts;
      }
      
      // If local cache is empty, fetch from remote
      final remoteProducts = await remoteDataSource.getAllProducts();
      
      // Cache the remote data locally
      await localDataSource.cacheProducts(remoteProducts);
      
      return remoteProducts;
    } catch (e) {
      // If both fail, return empty list
      return [];
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      // First try to get from local cache
      final localProduct = await localDataSource.getProductById(id);
      
      if (localProduct != null) {
        return localProduct;
      }
      
      // If not in local cache, fetch from remote
      final remoteProduct = await remoteDataSource.getProductById(id);
      
      if (remoteProduct != null) {
        // Cache the product locally
        await localDataSource.createProduct(remoteProduct);
        return remoteProduct;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      
      // Create on remote first
      await remoteDataSource.createProduct(productModel);
      
      // Then cache locally
      await localDataSource.createProduct(productModel);
    } catch (e) {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      
      // Update on remote first
      await remoteDataSource.updateProduct(productModel);
      
      // Then update local cache
      await localDataSource.updateProduct(productModel);
    } catch (e) {
      throw Exception('Failed to update product');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      // Delete from remote first
      await remoteDataSource.deleteProduct(id);
      
      // Then remove from local cache
      await localDataSource.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product');
    }
  }
} 