import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/core/error/exceptions.dart';
import 'package:interview_flutter/features/products/data/datasources/product_remote_data_source.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';

// ---------------------------------------------------------------------------
// Shared fake data
// ---------------------------------------------------------------------------

const Map<String, dynamic> _fakeProductJson = <String, dynamic>{
  'id': 1,
  'title': 'Essence Mascara Lash Princess',
  'description': 'Popular mascara',
  'price': 9.99,
  'discountPercentage': 7.17,
  'rating': 4.94,
  'stock': 5,
  'brand': 'Essence',
  'category': 'beauty',
  'thumbnail': 'https://cdn.dummyjson.com/thumb.jpg',
  'images': <String>['https://cdn.dummyjson.com/img1.jpg'],
};

Map<String, dynamic> _fakeListResponseJson() => <String, dynamic>{
      'products': <Map<String, dynamic>>[_fakeProductJson],
      'total': 30,
      'skip': 0,
      'limit': 10,
    };

const List<Map<String, dynamic>> _fakeCategoriesJson =
    <Map<String, dynamic>>[
  <String, dynamic>{
    'slug': 'beauty',
    'name': 'Beauty',
    'url': 'https://dummyjson.com/products/category/beauty',
  },
  <String, dynamic>{
    'slug': 'electronics',
    'name': 'Electronics',
    'url': 'https://dummyjson.com/products/category/electronics',
  },
];

// ---------------------------------------------------------------------------
// Helpers — create a Dio that intercepts requests and captures RequestOptions
// ---------------------------------------------------------------------------

Dio _mockDio({required Object responseData}) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            data: responseData,
            statusCode: 200,
          ),
        );
      },
    ),
  );
  return dio;
}

/// Wraps [dio] with an extra interceptor that records the [RequestOptions].
RequestOptions? _captureRequest(Dio dio) {
  RequestOptions? captured;
  dio.interceptors.insert(
    0,
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        captured = options;
        handler.next(options);
      },
    ),
  );
  // Return value is always null at call-site; read `captured` after the
  // data-source call completes.
  return captured;
}

Dio _rejectingDio({
  required DioExceptionType type,
  int? statusCode,
  String? statusMessage,
}) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: type,
            response: statusCode != null
                ? Response<dynamic>(
                    requestOptions: options,
                    statusCode: statusCode,
                    statusMessage: statusMessage,
                  )
                : null,
          ),
        );
      },
    ),
  );
  return dio;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ---- Remaining data-source endpoints ----

  group('ProductRemoteDataSource.searchProducts', () {
    test('calls /products/search with q, limit, skip', () async {
      final Dio dio = _mockDio(responseData: _fakeListResponseJson());
      RequestOptions? captured;
      dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );

      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);
      final ProductListResponse result =
          await ds.searchProducts('mascara', limit: 10, skip: 0);

      expect(captured?.path, '/products/search');
      expect(captured?.queryParameters['q'], 'mascara');
      expect(captured?.queryParameters['limit'], 10);
      expect(captured?.queryParameters['skip'], 0);
      expect(result.products, hasLength(1));
    });
  });

  group('ProductRemoteDataSource.getCategories', () {
    test('calls /products/categories and parses list', () async {
      final Dio dio = _mockDio(responseData: _fakeCategoriesJson);
      _captureRequest(dio);

      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);
      final categories = await ds.getCategories();

      expect(categories, hasLength(2));
      expect(categories.first.slug, 'beauty');
      expect(categories.last.slug, 'electronics');
    });
  });

  group('ProductRemoteDataSource.getProductsByCategory', () {
    test('calls /products/category/{slug} with limit and skip', () async {
      final Dio dio = _mockDio(responseData: _fakeListResponseJson());
      RequestOptions? captured;
      dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );

      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);
      final ProductListResponse result =
          await ds.getProductsByCategory('beauty', limit: 10, skip: 0);

      expect(captured?.path, '/products/category/beauty');
      expect(captured?.queryParameters['limit'], 10);
      expect(result.products, hasLength(1));
    });
  });

  group('ProductRemoteDataSource.getProductById', () {
    test('calls /products/{id} and parses single product', () async {
      final Dio dio = _mockDio(responseData: _fakeProductJson);
      RequestOptions? captured;
      dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );

      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);
      final ProductModel result = await ds.getProductById(42);

      expect(captured?.path, '/products/42');
      expect(result.id, 1);
      expect(result.title, 'Essence Mascara Lash Princess');
    });
  });

  // ---- _handleDioError branches ----

  group('ProductRemoteDataSource error mapping', () {
    test('connectionError → NetworkException', () async {
      final Dio dio = _rejectingDio(type: DioExceptionType.connectionError);
      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);

      expect(
        () => ds.getProducts(limit: 10, skip: 0),
        throwsA(isA<NetworkException>()),
      );
    });

    test('connectionTimeout → NetworkException', () async {
      final Dio dio = _rejectingDio(type: DioExceptionType.connectionTimeout);
      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);

      expect(
        () => ds.getProducts(limit: 10, skip: 0),
        throwsA(isA<NetworkException>()),
      );
    });

    test('badResponse 500 → ServerException with statusCode', () async {
      final Dio dio = _rejectingDio(
        type: DioExceptionType.badResponse,
        statusCode: 500,
        statusMessage: 'Internal Server Error',
      );
      final ProductRemoteDataSource ds = ProductRemoteDataSource(dio);

      try {
        await ds.getProducts(limit: 10, skip: 0);
        fail('Expected ServerException');
      } on ServerException catch (e) {
        expect(e.statusCode, 500);
        expect(e.message, 'Internal Server Error');
      }
    });
  });
}
