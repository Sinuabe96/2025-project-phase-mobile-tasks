import '../errors/network_exception.dart';

/// Utility class for standardized error handling
class ErrorHandler {
  /// Handle network errors with consistent messaging
  static Exception handleNetworkError(dynamic error, String operation) {
    if (error is NetworkException) {
      return error;
    }
    
    if (error is Exception) {
      return NetworkException('$operation failed: ${error.toString()}');
    }
    
    return NetworkException('$operation failed: Unknown error occurred');
  }

  /// Handle storage errors with consistent messaging
  static Exception handleStorageError(dynamic error, String operation) {
    if (error is Exception) {
      return Exception('$operation failed: ${error.toString()}');
    }
    
    return Exception('$operation failed: Unknown storage error occurred');
  }

  /// Handle API response errors
  static Exception handleApiError(int statusCode, String operation) {
    switch (statusCode) {
      case 400:
        return NetworkException('$operation failed: Bad request');
      case 401:
        return NetworkException('$operation failed: Unauthorized');
      case 403:
        return NetworkException('$operation failed: Forbidden');
      case 404:
        return NetworkException('$operation failed: Resource not found');
      case 500:
        return NetworkException('$operation failed: Server error');
      default:
        return NetworkException('$operation failed: HTTP $statusCode');
    }
  }

  /// Log error for debugging (can be extended for analytics)
  static void logError(String operation, dynamic error) {
    print('Error in $operation: $error');
    // TODO: Add proper logging service integration
  }
} 