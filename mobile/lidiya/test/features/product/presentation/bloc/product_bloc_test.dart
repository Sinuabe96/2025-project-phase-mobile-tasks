import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lidiya/features/product/presentation/bloc/product_bloc.dart';
import 'package:lidiya/features/product/presentation/bloc/product_event.dart';
import 'package:lidiya/features/product/presentation/bloc/product_state.dart';
import 'package:lidiya/features/product/domain/entities/product.dart';
import 'package:lidiya/features/product/domain/usecases/view_all_products.dart';
import 'package:lidiya/features/product/domain/usecases/view_product.dart';
import 'package:lidiya/features/product/domain/usecases/update_product.dart';
import 'package:lidiya/features/product/domain/usecases/delete_product.dart';
import 'package:lidiya/features/product/domain/usecases/create_product.dart';

// Generate mocks for use cases
generateMocks([
  ViewAllProductsUsecase,
  ViewProductUsecase,
  UpdateProductUsecase,
  DeleteProductUsecase,
  CreateProductUsecase,
]);

import 'product_bloc_test.mocks.dart';

void main() {
  late ProductBloc bloc;
  late MockViewAllProductsUsecase mockViewAllProducts;
  late MockViewProductUsecase mockViewProduct;
  late MockUpdateProductUsecase mockUpdateProduct;
  late MockDeleteProductUsecase mockDeleteProduct;
  late MockCreateProductUsecase mockCreateProduct;

  setUp(() {
    mockViewAllProducts = MockViewAllProductsUsecase();
    mockViewProduct = MockViewProductUsecase();
    mockUpdateProduct = MockUpdateProductUsecase();
    mockDeleteProduct = MockDeleteProductUsecase();
    mockCreateProduct = MockCreateProductUsecase();
    bloc = ProductBloc(
      getAllProducts: mockViewAllProducts,
      getSingleProduct: mockViewProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
      createProduct: mockCreateProduct,
    );
  });

  test('initial state is InitialState', () {
    expect(bloc.state, InitialState());
  });

  group('LoadAllProductsEvent', () {
    final products = [Product(id: 1, name: 'Test', price: 10.0)];
    blocTest<ProductBloc, ProductState>(
      'emits [LoadingState, LoadedAllProductsState] when successful',
      build: () {
        when(mockViewAllProducts()).thenAnswer((_) async => products);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [LoadingState(), LoadedAllProductsState(products)],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [LoadingState, ErrorState] when failure',
      build: () {
        when(mockViewAllProducts()).thenThrow(Exception('error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [LoadingState(), isA<ErrorState>()],
    );
  });

  // Add similar tests for GetSingleProductEvent, UpdateProductEvent, DeleteProductEvent, CreateProductEvent
}