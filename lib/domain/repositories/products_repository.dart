import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/product_category.dart';
import 'package:interview_flutter/domain/core/result.dart';

abstract class ProductsRepository {
  Future<Result<AllProductList>> getAllProducts({
    int limit = 10,
    int skip = 0,
  });
  Future<Result<AllProductList>> searchProducts(
    String productName, {
    int limit = 10,
    int skip = 0,
  });
  Future<Result<List<ProductCategory>>> getProductCategories();
  Future<Result<AllProductList>> getProductsByCategory(
    String category, {
    int limit = 10,
    int skip = 0,
  });
}
