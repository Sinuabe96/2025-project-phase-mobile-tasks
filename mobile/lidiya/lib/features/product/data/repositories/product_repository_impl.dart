import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/product_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/errors/network_exception.dart';

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
            print('Remote fetch failed, using cached data: $e');
            return localProducts;
          }
          // If both fail, throw network exception
          throw NetworkException('Failed to fetch products from remote and no cached data available');
        }
      } else {
        // Network unavailable, return local data
        if (localProducts.isNotEmpty) {
          print('No network connection, using cached data');
          return localProducts;
        } else {
          throw NoNetworkConnectionException();
        }
      }
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw NetworkException('Unexpected error while fetching products: $e');
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
          if (localProduct != null) {
            print('Remote fetch failed for product $id, using cached data: $e');
            return localProduct;
          }
          throw NetworkException('Failed to fetch product $id from remote and no cached data available');
        }
      }
      
      // Return local product or null
      if (localProduct != null) {
        print('No network connection, using cached product $id');
        return localProduct;
      }
      
      return null;
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw NetworkException('Unexpected error while fetching product $id: $e');
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
          print('Product created successfully on remote: ${product.name}');
        } catch (e) {
          // If remote fails, still cache locally for offline support
          print('Remote creation failed, caching locally for offline support: $e');
        }
      } else {
        print('No network connection, caching product locally for offline support');
      }
      
      // Always cache locally for offline support
      await localDataSource.createProduct(productModel);
    } catch (e) {
      throw NetworkException('Failed to create product: $e');
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
          print('Product updated successfully on remote: ${product.name}');
        } catch (e) {
          // If remote fails, still update locally for offline support
          print('Remote update failed, updating locally for offline support: $e');
        }
      } else {
        print('No network connection, updating product locally for offline support');
      }
      
      // Always update local cache for offline support
      await localDataSource.updateProduct(productModel);
    } catch (e) {
      throw NetworkException('Failed to update product: $e');
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
          print('Product deleted successfully from remote: $id');
        } catch (e) {
          // If remote fails, still delete locally for offline support
          print('Remote deletion failed, deleting locally for offline support: $e');
        }
      } else {
        print('No network connection, deleting product locally for offline support');
      }
      
      // Always remove from local cache for offline support
      await localDataSource.deleteProduct(id);
    } catch (e) {
      throw NetworkException('Failed to delete product: $e');
    }
  }
} 