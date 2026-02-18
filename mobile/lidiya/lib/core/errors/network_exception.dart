/// Exception thrown when network operations fail
class NetworkException implements Exception {
  final String message;
  final String? code;

  NetworkException(this.message, {this.code});

  @override
  String toString() => 'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when no network connection is available
class NoNetworkConnectionException extends NetworkException {
  NoNetworkConnectionException() : super('No network connection available');
}

/// Exception thrown when network operation times out
class NetworkTimeoutException extends NetworkException {
  NetworkTimeoutException() : super('Network operation timed out');
} 