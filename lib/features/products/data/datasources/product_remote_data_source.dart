import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  const ProductRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.products,
        queryParameters: <String, dynamic>{'limit': limit, 'skip': skip},
      );
      return ProductListResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.searchProducts,
        queryParameters: <String, dynamic>{
          'q': query,
          'limit': limit,
          'skip': skip,
        },
      );
      return ProductListResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get<List<dynamic>>(ApiEndpoints.categories);
      return response.data!
          .map(
            (dynamic item) =>
                CategoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.productsByCategory(category),
        queryParameters: <String, dynamic>{'limit': limit, 'skip': skip},
      );
      return ProductListResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.productDetail(id),
      );
      return ProductModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkException('No internet connection');
    }
    return ServerException(
      e.response?.statusMessage ?? 'Server error',
      statusCode: e.response?.statusCode,
    );
  }
}
