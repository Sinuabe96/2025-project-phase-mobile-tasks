/// Constants for API operations and configurations
class ApiConstants {
  // Base URLs
  static const String defaultBaseUrl = 'https://api.example.com/products';
  static const String mockBaseUrl = 'https://mock-api.com/products';
  
  // HTTP Headers
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // HTTP Status Codes
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
  
  // Storage Keys
  static const String cachedProductsKey = 'cached_products';
  static const String productPrefix = 'product_';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection failed';
  static const String serverErrorMessage = 'Server error occurred';
  static const String timeoutErrorMessage = 'Request timed out';
  static const String unknownErrorMessage = 'Unknown error occurred';
} 