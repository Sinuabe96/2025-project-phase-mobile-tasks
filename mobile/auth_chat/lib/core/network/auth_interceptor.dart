import 'package:dio/dio.dart';
import 'package:auth_chat/service_locator.dart';
import 'package:auth_chat/features/auth/data/source/auth_local_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for login and register endpoints
    if (options.path.contains('/auth/login') || options.path.contains('/auth/register')) {
      handler.next(options);
      return;
    }

    // Add auth token to protected endpoints
    try {
      final token = await sl<AuthLocalService>().getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Token not available, continue without auth
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear auth data and redirect to login
      sl<AuthLocalService>().clearAuth();
    }
    handler.next(err);
  }
} 