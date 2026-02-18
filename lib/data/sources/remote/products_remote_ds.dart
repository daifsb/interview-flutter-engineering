import 'package:dio/dio.dart';
import 'package:interview_flutter/core/api/api_endpoints.dart';
import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/product_category.dart';

class ProductsRemoteDataSource {
  final Dio _dio;

  const ProductsRemoteDataSource(this._dio);

  Future<AllProductList> getAllProducts({int limit = 10, int skip = 0}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return AllProductList.fromJson(response.data!);
  }

  Future<AllProductList> serachProducts(
    String productName, {
    int limit = 10,
    int skip = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.products}/search',
      queryParameters: {
        'q': productName,
        'limit': limit,
        'skip': skip,
      },
    );
    return AllProductList.fromJson(response.data!);
  }

  Future<List<ProductCategory>> getProductCategories() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.categories,
    );
    return (response.data as List<dynamic>)
        .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AllProductList> getProductsByCategory(
    String category, {
    int limit = 10,
    int skip = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.productsByCategory(category),
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return AllProductList.fromJson(response.data!);
  }
}
