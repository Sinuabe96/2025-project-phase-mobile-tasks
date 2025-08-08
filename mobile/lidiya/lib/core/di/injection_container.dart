import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_info.dart';
import '../network/network_info_impl.dart';
import '../../features/product/data/datasources/local_data_source.dart';
import '../../features/product/data/datasources/local_data_source_impl.dart';
import '../../features/product/data/datasources/remote_data_source.dart';
import '../../features/product/data/datasources/remote_data_source_impl.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/create_product.dart';
import '../../features/product/domain/usecases/delete_product.dart';
import '../../features/product/domain/usecases/update_product.dart';
import '../../features/product/domain/usecases/view_all_products.dart';
import '../../features/product/domain/usecases/view_product.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getAllProducts: sl(),
      getSingleProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      createProduct: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ViewAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => ViewProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => CreateProductUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(prefs: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
} 