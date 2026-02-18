import '../../features/product/domain/entities/product.dart';
import '../../features/product/data/models/product_model.dart';
import '../utils/error_handler.dart';

/// Base repository class providing common functionality
abstract class BaseRepository {
  /// Convert ProductModel to Product entity
  Product _convertToEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      price: model.price,
    );
  }

  /// Convert Product entity to ProductModel
  ProductModel _convertToModel(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
  }

  /// Convert list of ProductModel to list of Product entities
  List<Product> _convertToEntityList(List<ProductModel> models) {
    return models.map((model) => _convertToEntity(model)).toList();
  }

  /// Convert list of Product entities to list of ProductModel
  List<ProductModel> _convertToModelList(List<Product> products) {
    return products.map((product) => _convertToModel(product)).toList();
  }

  /// Handle network errors with consistent messaging
  Exception _handleNetworkError(dynamic error, String operation) {
    ErrorHandler.logError(operation, error);
    return ErrorHandler.handleNetworkError(error, operation);
  }

  /// Handle storage errors with consistent messaging
  Exception _handleStorageError(dynamic error, String operation) {
    ErrorHandler.logError(operation, error);
    return ErrorHandler.handleStorageError(error, operation);
  }

  /// Validate product data
  bool _validateProduct(Product product) {
    return product.id.isNotEmpty &&
           product.name.isNotEmpty &&
           product.description.isNotEmpty &&
           product.imageUrl.isNotEmpty &&
           product.price > 0;
  }

  /// Validate product model data
  bool _validateProductModel(ProductModel product) {
    return product.id.isNotEmpty &&
           product.name.isNotEmpty &&
           product.description.isNotEmpty &&
           product.imageUrl.isNotEmpty &&
           product.price > 0;
  }

  /// Generate unique ID for new products
  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
} 