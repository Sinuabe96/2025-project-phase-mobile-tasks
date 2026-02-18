import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'local_data_source.dart';
import '../../../../core/utils/json_helper.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/api_constants.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences prefs;

  LocalDataSourceImpl({required this.prefs});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final productsJson = prefs.getStringList(ApiConstants.cachedProductsKey) ?? [];
      
      final decodedList = JsonHelper.decodeList(productsJson);
      return decodedList
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      ErrorHandler.logError('getAllProducts', e);
      return [];
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final productJson = prefs.getString('${ApiConstants.productPrefix}$id');
      
      if (productJson != null) {
        final decoded = JsonHelper.safeDecode(productJson);
        if (decoded != null) {
          return ProductModel.fromJson(decoded);
        }
      }
      return null;
    } catch (e) {
      ErrorHandler.logError('getProductById', e);
      return null;
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      final encoded = JsonHelper.safeEncode(product.toJson());
      if (encoded == null) {
        throw Exception('Failed to encode product data');
      }
      
      await prefs.setString(
        '${ApiConstants.productPrefix}${product.id}',
        encoded,
      );
      
      final existingProducts = await getAllProducts();
      existingProducts.add(product);
      await _cacheProductsList(existingProducts);
    } catch (e) {
      ErrorHandler.logError('createProduct', e);
      throw ErrorHandler.handleStorageError(e, 'createProduct');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final encoded = JsonHelper.safeEncode(product.toJson());
      if (encoded == null) {
        throw Exception('Failed to encode product data');
      }
     
      await prefs.setString(
        '${ApiConstants.productPrefix}${product.id}',
        encoded,
      );
      
      // Update cached products list
      final existingProducts = await getAllProducts();
      final index = existingProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        existingProducts[index] = product;
        await _cacheProductsList(existingProducts);
      }
    } catch (e) {
      ErrorHandler.logError('updateProduct', e);
      throw ErrorHandler.handleStorageError(e, 'updateProduct');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      // Remove individual product
      await prefs.remove('${ApiConstants.productPrefix}$id');
      
      // Update cached products list
      final existingProducts = await getAllProducts();
      existingProducts.removeWhere((product) => product.id == id);
      await _cacheProductsList(existingProducts);
    } catch (e) {
      ErrorHandler.logError('deleteProduct', e);
      throw ErrorHandler.handleStorageError(e, 'deleteProduct');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await _cacheProductsList(products);
      
      // Also cache individual products for quick access
      for (final product in products) {
        final encoded = JsonHelper.safeEncode(product.toJson());
        if (encoded != null) {
          await prefs.setString(
            '${ApiConstants.productPrefix}${product.id}',
            encoded,
          );
        }
      }
    } catch (e) {
      ErrorHandler.logError('cacheProducts', e);
      throw ErrorHandler.handleStorageError(e, 'cacheProducts');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Clear cached products list
      await prefs.remove(ApiConstants.cachedProductsKey);
      
      // Clear all individual product entries
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(ApiConstants.productPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      ErrorHandler.logError('clearCache', e);
      throw ErrorHandler.handleStorageError(e, 'clearCache');
    }
  }

  Future<void> _cacheProductsList(List<ProductModel> products) async {
    final productsJson = JsonHelper.encodeList(products);
    await prefs.setStringList(ApiConstants.cachedProductsKey, productsJson);
  }
} 