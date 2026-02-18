import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lidiya/features/product/data/datasources/local_data_source_impl.dart';
import 'package:lidiya/features/product/data/models/product_model.dart';

import 'local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late LocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = LocalDataSourceImpl(prefs: mockSharedPreferences);
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
    test('should return list of products when cached products exist', () async {
      // arrange
      final cachedProductsJson = [
        '{"id":"1","name":"Test Product","description":"Test Description","imageUrl":"https://example.com/image.png","price":99.99}',
        '{"id":"2","name":"Test Product 2","description":"Test Description 2","imageUrl":"https://example.com/image2.png","price":149.99}',
      ];
      when(mockSharedPreferences.getStringList('cached_products'))
          .thenReturn(cachedProductsJson);

      // act
      final result = await localDataSource.getAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].name, 'Test Product');
      expect(result[1].id, '2');
      expect(result[1].name, 'Test Product 2');
      verify(mockSharedPreferences.getStringList('cached_products')).called(1);
    });

    test('should return empty list when no cached products exist', () async {
      // arrange
      when(mockSharedPreferences.getStringList('cached_products'))
          .thenReturn(null);

      // act
      final result = await localDataSource.getAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 0);
      verify(mockSharedPreferences.getStringList('cached_products')).called(1);
    });

    test('should return empty list when cached data is corrupted', () async {
      // arrange
      final corruptedJson = ['invalid json'];
      when(mockSharedPreferences.getStringList('cached_products'))
          .thenReturn(corruptedJson);

      // act
      final result = await localDataSource.getAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 0);
      verify(mockSharedPreferences.getStringList('cached_products')).called(1);
    });
  });

  group('getProductById', () {
    test('should return product when product exists', () async {
      // arrange
      final productJson = '{"id":"1","name":"Test Product","description":"Test Description","imageUrl":"https://example.com/image.png","price":99.99}';
      when(mockSharedPreferences.getString('product_1'))
          .thenReturn(productJson);

      // act
      final result = await localDataSource.getProductById('1');

      // assert
      expect(result, isA<ProductModel>());
      expect(result!.id, '1');
      expect(result.name, 'Test Product');
      verify(mockSharedPreferences.getString('product_1')).called(1);
    });

    test('should return null when product does not exist', () async {
      // arrange
      when(mockSharedPreferences.getString('product_999'))
          .thenReturn(null);

      // act
      final result = await localDataSource.getProductById('999');

      // assert
      expect(result, isNull);
      verify(mockSharedPreferences.getString('product_999')).called(1);
    });

    test('should return null when product data is corrupted', () async {
      // arrange
      when(mockSharedPreferences.getString('product_1'))
          .thenReturn('invalid json');

      // act
      final result = await localDataSource.getProductById('1');

      // assert
      expect(result, isNull);
      verify(mockSharedPreferences.getString('product_1')).called(1);
    });
  });

  group('createProduct', () {
    test('should create product successfully', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.getStringList('cached_products'))
          .thenReturn([]);
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      // act
      await localDataSource.createProduct(testProduct);

      // assert
      verify(mockSharedPreferences.setString('product_1', any)).called(1);
      verify(mockSharedPreferences.getStringList('cached_products')).called(1);
      verify(mockSharedPreferences.setStringList('cached_products', any)).called(1);
    });

    test('should throw exception when creation fails', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenThrow(Exception('Storage error'));

      // act & assert
      expect(
        () => localDataSource.createProduct(testProduct),
        throwsA(isA<Exception>()),
      );
      verify(mockSharedPreferences.setString('product_1', any)).called(1);
    });
  });

  group('updateProduct', () {
    test('should update product successfully', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.getStringList('cached_products'))
          .thenReturn(['{"id":"1","name":"Old Name","description":"Old Description","imageUrl":"https://example.com/old.png","price":50.0}']);
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      // act
      await localDataSource.updateProduct(testProduct);

      // assert
      verify(mockSharedPreferences.setString('product_1', any)).called(1);
      verify(mockSharedPreferences.getStringList('cached_products')).called(1);
      verify(mockSharedPreferences.setStringList('cached_products', any)).called(1);
    });

    test('should throw exception when update fails', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenThrow(Exception('Storage error'));

      // act & assert
      expect(
        () => localDataSource.updateProduct(testProduct),
        throwsA(isA<Exception>()),
      );
      verify(mockSharedPreferences.setString('product_1', any)).called(1);
    });
  });

  group('deleteProduct', () {
    test('should delete product successfully', () async {
      // arrange
      when(mockSharedPreferences.remove(any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.getStringList('cached_products'))
          .thenReturn(['{"id":"1","name":"Test Product","description":"Test Description","imageUrl":"https://example.com/image.png","price":99.99}']);
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      // act
      await localDataSource.deleteProduct('1');

      // assert
      verify(mockSharedPreferences.remove('product_1')).called(1);
      verify(mockSharedPreferences.getStringList('cached_products')).called(1);
      verify(mockSharedPreferences.setStringList('cached_products', any)).called(1);
    });

    test('should throw exception when deletion fails', () async {
      // arrange
      when(mockSharedPreferences.remove(any))
          .thenThrow(Exception('Storage error'));

      // act & assert
      expect(
        () => localDataSource.deleteProduct('1'),
        throwsA(isA<Exception>()),
      );
      verify(mockSharedPreferences.remove('product_1')).called(1);
    });
  });

  group('cacheProducts', () {
    test('should cache products successfully', () async {
      // arrange
      final products = [testProduct, testProduct2];
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // act
      await localDataSource.cacheProducts(products);

      // assert
      verify(mockSharedPreferences.setStringList('cached_products', any)).called(1);
      verify(mockSharedPreferences.setString('product_1', any)).called(1);
      verify(mockSharedPreferences.setString('product_2', any)).called(1);
    });

    test('should throw exception when caching fails', () async {
      // arrange
      final products = [testProduct];
      when(mockSharedPreferences.setStringList(any, any))
          .thenThrow(Exception('Storage error'));

      // act & assert
      expect(
        () => localDataSource.cacheProducts(products),
        throwsA(isA<Exception>()),
      );
      verify(mockSharedPreferences.setStringList('cached_products', any)).called(1);
    });
  });

  group('clearCache', () {
    test('should clear cache successfully', () async {
      // arrange
      when(mockSharedPreferences.remove(any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.getKeys())
          .thenReturn({'product_1', 'product_2', 'other_key'});

      // act
      await localDataSource.clearCache();

      // assert
      verify(mockSharedPreferences.remove('cached_products')).called(1);
      verify(mockSharedPreferences.remove('product_1')).called(1);
      verify(mockSharedPreferences.remove('product_2')).called(1);
      verifyNever(mockSharedPreferences.remove('other_key'));
    });

    test('should throw exception when clearing cache fails', () async {
      // arrange
      when(mockSharedPreferences.remove(any))
          .thenThrow(Exception('Storage error'));

      // act & assert
      expect(
        () => localDataSource.clearCache(),
        throwsA(isA<Exception>()),
      );
      verify(mockSharedPreferences.remove('cached_products')).called(1);
    });
  });
} 