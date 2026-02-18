import 'package:flutter_test/flutter_test.dart';
import 'package:lidiya/core/di/injection_container.dart' as di;
import 'package:lidiya/features/product/presentation/bloc/product_bloc.dart';
import 'package:lidiya/features/product/domain/usecases/view_all_products.dart';
import 'package:lidiya/features/product/domain/usecases/view_product.dart';
import 'package:lidiya/features/product/domain/usecases/update_product.dart';
import 'package:lidiya/features/product/domain/usecases/delete_product.dart';
import 'package:lidiya/features/product/domain/usecases/create_product.dart';

void main() {
  setUpAll(() async {
    await di.init();
  });

  group('Dependency Injection Tests', () {
    test('should register ProductBloc as factory', () {
      final bloc1 = di.sl<ProductBloc>();
      final bloc2 = di.sl<ProductBloc>();
      
      expect(bloc1, isA<ProductBloc>());
      expect(bloc2, isA<ProductBloc>());
      expect(bloc1, isNot(same(bloc2))); // Factory should create new instances
    });

    test('should register ViewAllProductsUsecase as singleton', () {
      final useCase1 = di.sl<ViewAllProductsUsecase>();
      final useCase2 = di.sl<ViewAllProductsUsecase>();
      
      expect(useCase1, isA<ViewAllProductsUsecase>());
      expect(useCase1, same(useCase2)); // Singleton should return same instance
    });

    test('should register ViewProductUsecase as singleton', () {
      final useCase = di.sl<ViewProductUsecase>();
      expect(useCase, isA<ViewProductUsecase>());
    });

    test('should register UpdateProductUsecase as singleton', () {
      final useCase = di.sl<UpdateProductUsecase>();
      expect(useCase, isA<UpdateProductUsecase>());
    });

    test('should register DeleteProductUsecase as singleton', () {
      final useCase = di.sl<DeleteProductUsecase>();
      expect(useCase, isA<DeleteProductUsecase>());
    });

    test('should register CreateProductUsecase as singleton', () {
      final useCase = di.sl<CreateProductUsecase>();
      expect(useCase, isA<CreateProductUsecase>());
    });
  });
} 