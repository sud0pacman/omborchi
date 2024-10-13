import 'package:get_it/get_it.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/category_remote_data_source.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/product_remote_data_source.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/raw_material_remote_data_source.dart';
import 'package:omborchi/feature/main/data/data_sources/remote_data_source/type_remote_data_source.dart';
import 'package:omborchi/feature/main/data/repository_impl/category_repository_impl.dart';
import 'package:omborchi/feature/main/data/repository_impl/product_repository_impl.dart';
import 'package:omborchi/feature/main/data/repository_impl/raw_material_repository_impl.dart';
import 'package:omborchi/feature/main/data/repository_impl/type_repository_impl.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';
import 'package:omborchi/feature/main/domain/repository/product_repository.dart';
import 'package:omborchi/feature/main/domain/repository/raw_material_repository.dart';
import 'package:omborchi/feature/main/domain/repository/type_repository.dart';
import 'package:omborchi/feature/main/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:omborchi/feature/main/presentation/bloc/category/category_bloc.dart';
import 'package:omborchi/feature/main/presentation/bloc/raw_material/raw_material_bloc.dart';
import 'package:omborchi/feature/main/presentation/bloc/raw_material_type/raw_material_type_bloc.dart';
import 'package:omborchi/feature/main/presentation/bloc/update_product/update_product_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
String? currentJwtToken;
Stream<String?>? jwtTokenStream;

Future<void> initDependencies() async {
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  final supabase = Supabase.instance.client;

  serviceLocator.registerLazySingleton(() => supabase);

  _initProduct();
  _initCategory();
  _initType();
  _initRawMaterials();
}

void _initProduct() {
  serviceLocator
    ..registerFactory<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => AddProductBloc(serviceLocator()))
    ..registerFactory(() => UpdateProductBloc(serviceLocator(), serviceLocator(), serviceLocator()));
}

void _initRawMaterials() {
  serviceLocator
    ..registerFactory<RawMaterialRemoteDataSource>(
      () => RawMaterialRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<RawMaterialRepository>(
      () => RawMaterialRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => RawMaterialBloc(serviceLocator()));
}

void _initCategory() {
  serviceLocator
    ..registerFactory<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<CategoryRepository>(
      () => CategoryRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => CategoryBloc(serviceLocator()));
}

void _initType() {
  serviceLocator
    ..registerFactory<TypeRemoteDataSource>(
      () => TypeRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<TypeRepository>(
      () => TypeRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => RawMaterialTypeBloc(serviceLocator()));
}
