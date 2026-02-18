import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../domain/usecases/view_all_products.dart';
import '../../domain/usecases/view_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/create_product.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUsecase getAllProducts;
  final ViewProductUsecase getSingleProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;
  final CreateProductUsecase createProduct;

  ProductBloc({
    required this.getAllProducts,
    required this.getSingleProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.createProduct,
  }) : super(InitialState()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<CreateProductEvent>(_onCreateProduct);
  }

  Future<void> _onLoadAllProducts(
      LoadAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      final products = await getAllProducts();
      emit(LoadedAllProductsState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onGetSingleProduct(
      GetSingleProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      final product = await getSingleProduct(event.id.toString());
      if (product != null) {
        emit(LoadedSingleProductState(product));
      } else {
        emit(ErrorState('Product not found'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      await updateProduct(event.product);
      add(LoadAllProductsEvent());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      await deleteProduct(event.id.toString());
      add(LoadAllProductsEvent());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
      CreateProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      await createProduct(event.product);
      add(LoadAllProductsEvent());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}