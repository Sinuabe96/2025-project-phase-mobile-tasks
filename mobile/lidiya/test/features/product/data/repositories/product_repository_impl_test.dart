import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lidiya/features/product/data/repositories/product_repository_impl.dart';
import 'package:lidiya/features/product/data/datasources/remote_data_source.dart';
import 'package:lidiya/features/product/data/datasources/local_data_source.dart';
import 'package:lidiya/features/product/data/models/product_model.dart';
import 'package:lidiya/features/product/domain/entities/product.dart';
import 'package:lidiya/core/network/network_info.dart';
import 'package:lidiya/core/errors/network_exception.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource, LocalDataSource, NetworkInfo])
void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'https://example.com/image.png',
    price: 99.99,
  );

  final testProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'https://example.com/image.png',
    price: 99.99,
  );

  group('getAllProducts', () {
    test('should return remote products when network is available and remote succeeds', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAllProducts())
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getAllProducts())
          .thenAnswer((_) async => [testProductModel]);
      when(mockLocalDataSource.cacheProducts(any))
          .thenAnswer((_) async => null);

      // act
      final result = await repository.getAllProducts();

      // assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first.name, 'Test Product');
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.getAllProducts()).called(1);
      verify(mockLocalDataSource.cacheProducts(any)).called(1);
    });

    test('should return local products when network is unavailable', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProducts())
          .thenAnswer((_) async => [testProductModel]);

      // act
      final result = await repository.getAllProducts();

      // assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first.name, 'Test Product');
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockLocalDataSource.getAllProducts()).called(1);
      verifyNever(mockRemoteDataSource.getAllProducts());
    });

    test('should return local products when network is available but remote fails', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAllProducts())
          .thenAnswer((_) async => [testProductModel]);
      when(mockRemoteDataSource.getAllProducts())
          .thenThrow(Exception('Network error'));

      // act
      final result = await repository.getAllProducts();

      // assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first.name, 'Test Product');
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.getAllProducts()).called(1);
      verify(mockLocalDataSource.getAllProducts()).called(1);
    });

    test('should throw NetworkException when both network and local fail', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAllProducts())
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getAllProducts())
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () => repository.getAllProducts(),
        throwsA(isA<NetworkException>()),
      );
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.getAllProducts()).called(1);
      verify(mockLocalDataSource.getAllProducts()).called(1);
    });

    test('should throw NoNetworkConnectionException when no network and no local data', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProducts())
          .thenAnswer((_) async => []);

      // act & assert
      expect(
        () => repository.getAllProducts(),
        throwsA(isA<NoNetworkConnectionException>()),
      );
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockLocalDataSource.getAllProducts()).called(1);
      verifyNever(mockRemoteDataSource.getAllProducts());
    });
  });

  group('getProductById', () {
    test('should return remote product when network is available and product found', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getProductById('1'))
          .thenAnswer((_) async => null);
      when(mockRemoteDataSource.getProductById('1'))
          .thenAnswer((_) async => testProductModel);
      when(mockLocalDataSource.createProduct(any))
          .thenAnswer((_) async => null);

      // act
      final result = await repository.getProductById('1');

      // assert
      expect(result, isA<Product>());
      expect(result?.name, 'Test Product');
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.getProductById('1')).called(1);
      verify(mockLocalDataSource.createProduct(any)).called(1);
    });

    test('should return local product when network is unavailable', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getProductById('1'))
          .thenAnswer((_) async => testProductModel);

      // act
      final result = await repository.getProductById('1');

      // assert
      expect(result, isA<Product>());
      expect(result?.name, 'Test Product');
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockLocalDataSource.getProductById('1')).called(1);
      verifyNever(mockRemoteDataSource.getProductById(any));
    });

    test('should return local product when network is available but remote fails', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getProductById('1'))
          .thenAnswer((_) async => testProductModel);
      when(mockRemoteDataSource.getProductById('1'))
          .thenThrow(Exception('Network error'));

      // act
      final result = await repository.getProductById('1');

      // assert
      expect(result, isA<Product>());
      expect(result?.name, 'Test Product');
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.getProductById('1')).called(1);
      verify(mockLocalDataSource.getProductById('1')).called(1);
    });

    test('should throw NetworkException when remote fails and no local data', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getProductById('1'))
          .thenAnswer((_) async => null);
      when(mockRemoteDataSource.getProductById('1'))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () => repository.getProductById('1'),
        throwsA(isA<NetworkException>()),
      );
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.getProductById('1')).called(1);
      verify(mockLocalDataSource.getProductById('1')).called(1);
    });
  });

  group('createProduct', () {
    test('should create product on remote and local when network is available', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.createProduct(any))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.createProduct(any))
          .thenAnswer((_) async => null);

      // act
      await repository.createProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.createProduct(any)).called(1);
      verify(mockLocalDataSource.createProduct(any)).called(1);
    });

    test('should create product only locally when network is unavailable', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.createProduct(any))
          .thenAnswer((_) async => null);

      // act
      await repository.createProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verifyNever(mockRemoteDataSource.createProduct(any));
      verify(mockLocalDataSource.createProduct(any)).called(1);
    });

    test('should still cache locally when remote creation fails', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.createProduct(any))
          .thenThrow(Exception('Remote error'));
      when(mockLocalDataSource.createProduct(any))
          .thenAnswer((_) async => null);

      // act
      await repository.createProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.createProduct(any)).called(1);
      verify(mockLocalDataSource.createProduct(any)).called(1);
    });
  });

  group('updateProduct', () {
    test('should update product on remote and local when network is available', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateProduct(any))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.updateProduct(any))
          .thenAnswer((_) async => null);

      // act
      await repository.updateProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.updateProduct(any)).called(1);
      verify(mockLocalDataSource.updateProduct(any)).called(1);
    });

    test('should update product only locally when network is unavailable', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.updateProduct(any))
          .thenAnswer((_) async => null);

      // act
      await repository.updateProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verifyNever(mockRemoteDataSource.updateProduct(any));
      verify(mockLocalDataSource.updateProduct(any)).called(1);
    });
  });

  group('deleteProduct', () {
    test('should delete product from remote and local when network is available', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteProduct('1'))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.deleteProduct('1'))
          .thenAnswer((_) async => null);

      // act
      await repository.deleteProduct('1');

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemoteDataSource.deleteProduct('1')).called(1);
      verify(mockLocalDataSource.deleteProduct('1')).called(1);
    });

    test('should delete product only locally when network is unavailable', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.deleteProduct('1'))
          .thenAnswer((_) async => null);

      // act
      await repository.deleteProduct('1');

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verifyNever(mockRemoteDataSource.deleteProduct(any));
      verify(mockLocalDataSource.deleteProduct('1')).called(1);
    });
  });
} 