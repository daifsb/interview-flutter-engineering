import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/product_category.dart';
import 'package:interview_flutter/data/sources/remote/products_remote_ds.dart';
import 'package:interview_flutter/domain/core/app_error.dart';
import 'package:interview_flutter/domain/core/result.dart';
import 'package:interview_flutter/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remote;
  const ProductsRepositoryImpl(this._remote);

  @override
  Future<Result<AllProductList>> getAllProducts({
    int limit = 100,
    int skip = 0,
  }) async {
    try {
      final result = await _remote.getAllProducts(limit: limit, skip: skip);
      return Success(result);
    } catch (e) {
      return Failure(AppError.from(e));
    }
  }

  @override
  Future<Result<List<ProductCategory>>> getProductCategories() async {
    try {
      final result = await _remote.getProductCategories();
      return Success(result);
    } catch (e) {
      return Failure(AppError.from(e));
    }
  }

  @override
  Future<Result<AllProductList>> getProductsByCategory(
    String category, {
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final result = await _remote.getProductsByCategory(
        category,
        limit: limit,
        skip: skip,
      );
      return Success(result);
    } catch (e) {
      return Failure(AppError.from(e));
    }
  }

  @override
  Future<Result<AllProductList>> searchProducts(
    String productName, {
    int limit = 100,
    int skip = 0,
  }) async {
    try {
      final result = await _remote.serachProducts(
        productName,
        limit: limit,
        skip: skip,
      );
      return Success(result);
    } catch (e) {
      return Failure(AppError.from(e));
    }
  }
}
