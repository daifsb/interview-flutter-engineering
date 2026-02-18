import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) =>
      _remoteDataSource.getProducts(limit: limit, skip: skip);

  @override
  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) =>
      _remoteDataSource.searchProducts(query, limit: limit, skip: skip);

  @override
  Future<List<CategoryModel>> getCategories() =>
      _remoteDataSource.getCategories();

  @override
  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) =>
      _remoteDataSource.getProductsByCategory(
        category,
        limit: limit,
        skip: skip,
      );

  @override
  Future<ProductModel> getProductById(int id) =>
      _remoteDataSource.getProductById(id);
}
