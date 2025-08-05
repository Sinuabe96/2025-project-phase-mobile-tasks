import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/product_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/base/base_repository.dart';

class ProductRepositoryImpl extends BaseRepository implements ProductRepository {
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
          
          return _convertToEntityList(remoteProducts);
        } catch (e) {
          // If remote fails but we have local data, return local
          if (localProducts.isNotEmpty) {
            print('Remote fetch failed, using cached data: $e');
            return _convertToEntityList(localProducts);
          }
          // If both fail, throw network exception
          throw _handleNetworkError(e, 'getAllProducts');
        }
      } else {
        // Network unavailable, return local data
        if (localProducts.isNotEmpty) {
          print('No network connection, using cached data');
          return _convertToEntityList(localProducts);
        } else {
          throw NoNetworkConnectionException();
        }
      }
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw _handleNetworkError(e, 'getAllProducts');
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
            return _convertToEntity(remoteProduct);
          }
        } catch (e) {
          // If remote fails, return local product if available
          if (localProduct != null) {
            print('Remote fetch failed for product $id, using cached data: $e');
            return _convertToEntity(localProduct);
          }
          throw _handleNetworkError(e, 'getProductById');
        }
      }
      
      // Return local product or null
      if (localProduct != null) {
        print('No network connection, using cached product $id');
        return _convertToEntity(localProduct);
      }
      
      return null;
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw _handleNetworkError(e, 'getProductById');
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    try {
      if (!_validateProduct(product)) {
        throw Exception('Invalid product data');
      }
      
      final productModel = _convertToModel(product);
      
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
      throw _handleNetworkError(e, 'createProduct');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      if (!_validateProduct(product)) {
        throw Exception('Invalid product data');
      }
      
      final productModel = _convertToModel(product);
      
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
      throw _handleNetworkError(e, 'updateProduct');
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
      throw _handleNetworkError(e, 'deleteProduct');
    }
  }

  List<Product> _convertToEntityList(List<ProductModel> models) {
    return models.map((model) => _convertToEntity(model)).toList();
  }

  Product _convertToEntity(ProductModel model) {
    // Assuming ProductModel extends/implements Product or has a toEntity() method
    // Adjust this conversion as per your actual model/entity structure
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      imageUrl: model.imageUrl,
      // Add other fields as necessary
    );
  }

  ProductModel _convertToModel(Product product) {
    // Adjust this conversion as per your actual model/entity structure
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      // Add other fields as necessary
    );
  }

  Exception _handleNetworkError(dynamic error, String methodName) {
    // You can customize this logic as needed
    if (error is NetworkException) {
      return error;
    }
    return NetworkException('Error in $methodName: ${error.toString()}');
  }

  bool _validateProduct(Product product) {
    // Basic validation: check required fields are not null or empty
    return product.id.isNotEmpty &&
        product.name.isNotEmpty;
  }
} 