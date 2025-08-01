import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/product_model.dart';
import '../../../../core/network/network_info.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      // First try to get from local cache
      final localProducts = await localDataSource.getAllProducts();
      
      // Check if network is available
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          // Fetch from remote when network is available
          final remoteProducts = await remoteDataSource.getAllProducts();
          
          // Cache the remote data locally
          await localDataSource.cacheProducts(remoteProducts);
          
          return remoteProducts;
        } catch (e) {
          // If remote fails but we have local data, return local
          if (localProducts.isNotEmpty) {
            return localProducts;
          }
          // If both fail, return empty list
          return [];
        }
      } else {
        // Network unavailable, return local data
        return localProducts;
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      // First try to get from local cache
      final localProduct = await localDataSource.getProductById(id);
      
      // Check if network is available
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          // Fetch from remote when network is available
          final remoteProduct = await remoteDataSource.getProductById(id);
          
          if (remoteProduct != null) {
            // Cache the product locally
            await localDataSource.createProduct(remoteProduct);
            return remoteProduct;
          }
        } catch (e) {
          // If remote fails, return local product if available
          return localProduct;
        }
      }
      
      // Return local product or null
      return localProduct;
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
      
      // Check if network is available
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          // Create on remote first when network is available
          await remoteDataSource.createProduct(productModel);
        } catch (e) {
          // If remote fails, still cache locally for offline support
          print('Remote creation failed, caching locally: $e');
        }
      }
      
      // Always cache locally for offline support
      await localDataSource.createProduct(productModel);
    } catch (e) {
      throw Exception('Failed to create product: $e');
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
      
      // Check if network is available
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          // Update on remote first when network is available
          await remoteDataSource.updateProduct(productModel);
        } catch (e) {
          // If remote fails, still update locally for offline support
          print('Remote update failed, updating locally: $e');
        }
      }
      
      // Always update local cache for offline support
      await localDataSource.updateProduct(productModel);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      // Check if network is available
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          // Delete from remote first when network is available
          await remoteDataSource.deleteProduct(id);
        } catch (e) {
          // If remote fails, still delete locally for offline support
          print('Remote deletion failed, deleting locally: $e');
        }
      }
      
      // Always remove from local cache for offline support
      await localDataSource.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
} 