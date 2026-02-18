import 'package:get_it/get_it.dart';
import 'package:interview_flutter/core/api/api_client.dart';
import 'package:interview_flutter/data/repositories/products_repository_impl.dart';
import 'package:interview_flutter/data/sources/remote/products_remote_ds.dart';
import 'package:interview_flutter/domain/repositories/products_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Data Sources
  getIt.registerSingleton<ProductsRemoteDataSource>(
    ProductsRemoteDataSource(ApiClient.instance.dio),
  );

  // Initialize Repositories
  getIt.registerSingleton<ProductsRepository>(
    ProductsRepositoryImpl(getIt()),
  );
}
