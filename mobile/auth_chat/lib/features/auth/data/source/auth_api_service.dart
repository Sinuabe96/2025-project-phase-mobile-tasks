import 'package:auth_chat/core/constants/api_urls.dart';
import 'package:auth_chat/core/network/dio_client.dart';
import 'package:auth_chat/features/auth/data/models/auth_response.dart';
import 'package:auth_chat/features/auth/data/models/login_req_params.dart';
import 'package:auth_chat/features/auth/data/models/signup_req_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:auth_chat/features/auth/data/source/auth_local_service.dart';
import 'package:auth_chat/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AuthApiService {
  Future<Either<String, AuthResponse>> signup(SignupReqParams signupRec);
  Future<Either<String, AuthResponse>> login(LoginReqParams loginRec);
  Future<Either<String, AuthResponse>> logout();
  Future<Either<String, UserModel>> getProfile();
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either<String, AuthResponse>> signup(SignupReqParams signupRec) async {
    try {
      print('Making signup API call to: ${ApiUrls.register}');
      print('Request data: ${signupRec.toMap()}');
      
      var response = await sl<DioClient>().post(
        ApiUrls.register,
        data: signupRec.toMap(),
      );

      print('Signup API call completed successfully');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return Right(AuthResponse.fromJson(response.data));
    } on DioException catch (e) {
      print('Signup API call failed with DioException');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left('Connection timeout. Please check your internet connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Left('No internet connection. Please check your network and try again.');
      } else if (e.response != null) {
        // Handle different response data structures
        var responseData = e.response?.data;
        String errorMessage = 'Registration failed';
        
        if (responseData is Map) {
          if (responseData.containsKey('message')) {
            errorMessage = responseData['message'].toString();
          } else if (responseData.containsKey('error')) {
            errorMessage = responseData['error'].toString();
          } else if (responseData.containsKey('detail')) {
            errorMessage = responseData['detail'].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        } else if (responseData is List) {
          errorMessage = responseData.join(', ');
        }
        
        return Left(errorMessage);
      } else {
        return Left('Registration failed. Please try again.');
      }
    } catch (e) {
      print('Signup API call failed with unexpected error: $e');
      return Left('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Either<String, AuthResponse>> login(LoginReqParams loginRec) async {
    try {
      print('Making login API call to: ${ApiUrls.login}');
      print('Request data: ${loginRec.toMap()}');
      
      var response = await sl<DioClient>().post(
        ApiUrls.login,
        data: loginRec.toMap(),
      );

      print('Login API call completed successfully');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      // For login, we need to get the user profile after successful login
      if (response.statusCode == 201) {
        // Store the access token (you might want to save this in shared preferences)
        var accessToken = response.data['data']['access_token'];
        print('Access token received: ${accessToken.substring(0, 20)}...');
        
        // Save the token
        await sl<AuthLocalService>().saveToken(accessToken);
        
        // Now get the user profile
        var profileResponse = await sl<DioClient>().get(
          ApiUrls.profile,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );
        
        print(profileResponse);
        print('Profile response: ${profileResponse.data}');
        
        // Create a response with the user data
        var userData = profileResponse.data['data'];
        var authResponseData = {
          'statusCode': response.statusCode,
          'message': response.data['message'] ?? '',
          'data': userData,
        };
        
        return Right(AuthResponse.fromJson(authResponseData));
      }

      return Right(AuthResponse.fromJson(response.data));
    } on DioException catch (e) {
      print('Login API call failed with DioException');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left('Connection timeout. Please check your internet connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Left('No internet connection. Please check your network and try again.');
      } else if (e.response != null) {
        // Handle different response data structures
        var responseData = e.response?.data;
        String errorMessage = 'Login failed';
        
        if (responseData is Map) {
          if (responseData.containsKey('message')) {
            errorMessage = responseData['message'].toString();
          } else if (responseData.containsKey('error')) {
            errorMessage = responseData['error'].toString();
          } else if (responseData.containsKey('detail')) {
            errorMessage = responseData['detail'].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        } else if (responseData is List) {
          errorMessage = responseData.join(', ');
        }
        
        return Left(errorMessage);
      } else {
        return Left('Login failed. Please try again.');
      }
    } catch (e) {
      print('Login API call failed with unexpected error: $e');
      return Left('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Either<String, AuthResponse>> logout() async {
    try {
      var response = await sl<DioClient>().post(ApiUrls.logout);
      return Right(AuthResponse.fromJson(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left('Connection timeout. Please check your internet connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Left('No internet connection. Please check your network and try again.');
      } else if (e.response != null) {
        return Left(e.response?.data['message'] ?? 'Logout failed');
      } else {
        return Left('Logout failed. Please try again.');
      }
    } catch (e) {
      return Left('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Either<String, UserModel>> getProfile() async {
    try {
      var response = await sl<DioClient>().get(ApiUrls.profile);
      return Right(UserModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left('Connection timeout. Please check your internet connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        return Left('No internet connection. Please check your network and try again.');
      } else if (e.response != null) {
        return Left(e.response?.data['message'] ?? 'Failed to get profile');
      } else {
        return Left('Failed to get profile. Please try again.');
      }
    } catch (e) {
      return Left('An unexpected error occurred. Please try again.');
    }
  }
}

