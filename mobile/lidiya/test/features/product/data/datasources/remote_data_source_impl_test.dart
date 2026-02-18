import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:lidiya/features/product/data/datasources/remote_data_source_impl.dart';
import 'package:lidiya/features/product/data/models/product_model.dart';

import 'remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late RemoteDataSourceImpl remoteDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = RemoteDataSourceImpl(
      client: mockHttpClient,
      baseUrl: 'https://api.example.com/products',
    );
  });

  final testProduct = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'https://example.com/image.png',
    price: 99.99,
  );

  final testProduct2 = ProductModel(
    id: '2',
    name: 'Test Product 2',
    description: 'Test Description 2',
    imageUrl: 'https://example.com/image2.png',
    price: 149.99,
  );

  group('getAllProducts', () {
    test('should return list of products when API call is successful', () async {
      // arrange
      final productsJson = [
        {
          'id': '1',
          'name': 'Test Product',
          'description': 'Test Description',
          'imageUrl': 'https://example.com/image.png',
          'price': 99.99,
        },
        {
          'id': '2',
          'name': 'Test Product 2',
          'description': 'Test Description 2',
          'imageUrl': 'https://example.com/image2.png',
          'price': 149.99,
        },
      ];

      when(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .thenAnswer((_) async => http.Response(
                json.encode(productsJson),
                200,
              ));

      // act
      final result = await remoteDataSource.getAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].name, 'Test Product');
      expect(result[1].id, '2');
      expect(result[1].name, 'Test Product 2');
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .called(1);
    });

    test('should throw exception when API call fails with non-200 status', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // act & assert
      expect(
        () => remoteDataSource.getAllProducts(),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .called(1);
    });

    test('should return mock products when API call throws exception', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .thenThrow(Exception('Network error'));

      // act
      final result = await remoteDataSource.getAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 3); // Mock products count
      expect(result[0].name, 'Nike Air Max');
      expect(result[1].name, 'Adidas Ultraboost');
      expect(result[2].name, 'Puma RS-X');
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .called(1);
    });

    test('should handle empty response from API', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .thenAnswer((_) async => http.Response('[]', 200));

      // act
      final result = await remoteDataSource.getAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 0);
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products')))
          .called(1);
    });
  });

  group('getProductById', () {
    test('should return product when API call is successful', () async {
      // arrange
      final productJson = {
        'id': '1',
        'name': 'Test Product',
        'description': 'Test Description',
        'imageUrl': 'https://example.com/image.png',
        'price': 99.99,
      };

      when(mockHttpClient.get(Uri.parse('https://api.example.com/products/1')))
          .thenAnswer((_) async => http.Response(
                json.encode(productJson),
                200,
              ));

      // act
      final result = await remoteDataSource.getProductById('1');

      // assert
      expect(result, isA<ProductModel>());
      expect(result!.id, '1');
      expect(result.name, 'Test Product');
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products/1')))
          .called(1);
    });

    test('should return null when product not found (404)', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.example.com/products/999')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final result = await remoteDataSource.getProductById('999');

      // assert
      expect(result, isNull);
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products/999')))
          .called(1);
    });

    test('should return mock product when API call throws exception', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.example.com/products/1')))
          .thenThrow(Exception('Network error'));

      // act
      final result = await remoteDataSource.getProductById('1');

      // assert
      expect(result, isA<ProductModel>());
      expect(result!.id, '1');
      expect(result.name, 'Nike Air Max');
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products/1')))
          .called(1);
    });

    test('should throw exception when product not found in mock data', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.example.com/products/999')))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () => remoteDataSource.getProductById('999'),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.get(Uri.parse('https://api.example.com/products/999')))
          .called(1);
    });
  });

  group('createProduct', () {
    test('should create product successfully when API call is successful', () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('https://api.example.com/products'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async => http.Response('Created', 201));

      // act
      await remoteDataSource.createProduct(testProduct);

      // assert
      verify(mockHttpClient.post(
        Uri.parse('https://api.example.com/products'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).called(1);
    });

    test('should throw exception when API call fails with non-201 status', () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('https://api.example.com/products'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async => http.Response('Bad Request', 400));

      // act & assert
      expect(
        () => remoteDataSource.createProduct(testProduct),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.post(
        Uri.parse('https://api.example.com/products'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).called(1);
    });

    test('should handle network exception gracefully', () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('https://api.example.com/products'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenThrow(Exception('Network error'));

      // act
      await remoteDataSource.createProduct(testProduct);

      // assert
      verify(mockHttpClient.post(
        Uri.parse('https://api.example.com/products'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).called(1);
      // Should not throw exception, just print message
    });
  });

  group('updateProduct', () {
    test('should update product successfully when API call is successful', () async {
      // arrange
      when(mockHttpClient.put(
        Uri.parse('https://api.example.com/products/1'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async => http.Response('OK', 200));

      // act
      await remoteDataSource.updateProduct(testProduct);

      // assert
      verify(mockHttpClient.put(
        Uri.parse('https://api.example.com/products/1'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).called(1);
    });

    test('should throw exception when API call fails with non-200 status', () async {
      // arrange
      when(mockHttpClient.put(
        Uri.parse('https://api.example.com/products/1'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // act & assert
      expect(
        () => remoteDataSource.updateProduct(testProduct),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.put(
        Uri.parse('https://api.example.com/products/1'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).called(1);
    });

    test('should handle network exception gracefully', () async {
      // arrange
      when(mockHttpClient.put(
        Uri.parse('https://api.example.com/products/1'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenThrow(Exception('Network error'));

      // act
      await remoteDataSource.updateProduct(testProduct);

      // assert
      verify(mockHttpClient.put(
        Uri.parse('https://api.example.com/products/1'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).called(1);
      // Should not throw exception, just print message
    });
  });

  group('deleteProduct', () {
    test('should delete product successfully when API call is successful', () async {
      // arrange
      when(mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')))
          .thenAnswer((_) async => http.Response('No Content', 204));

      // act
      await remoteDataSource.deleteProduct('1');

      // assert
      verify(mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')))
          .called(1);
    });

    test('should throw exception when API call fails with non-204 status', () async {
      // arrange
      when(mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act & assert
      expect(
        () => remoteDataSource.deleteProduct('1'),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')))
          .called(1);
    });

    test('should handle network exception gracefully', () async {
      // arrange
      when(mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')))
          .thenThrow(Exception('Network error'));

      // act
      await remoteDataSource.deleteProduct('1');

      // assert
      verify(mockHttpClient.delete(Uri.parse('https://api.example.com/products/1')))
          .called(1);
      // Should not throw exception, just print message
    });
  });

  group('custom base URL', () {
    test('should use custom base URL when provided', () async {
      // arrange
      final customRemoteDataSource = RemoteDataSourceImpl(
        client: mockHttpClient,
        baseUrl: 'https://custom-api.com/v1/products',
      );

      when(mockHttpClient.get(Uri.parse('https://custom-api.com/v1/products')))
          .thenAnswer((_) async => http.Response('[]', 200));

      // act
      await customRemoteDataSource.getAllProducts();

      // assert
      verify(mockHttpClient.get(Uri.parse('https://custom-api.com/v1/products')))
          .called(1);
    });
  });
} 