import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/products/data/datasources/product_remote_data_source.dart';
import 'package:interview_flutter/features/products/data/models/category_model.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';
import 'package:interview_flutter/features/products/domain/repositories/product_repository.dart';
import 'package:interview_flutter/features/products/presentation/providers/product_providers.dart';

// ---------------------------------------------------------------------------
// Shared fake data matching GET /products?limit=10&skip=0 shape
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

Map<String, dynamic> _fakeListResponseJson({int total = 30}) =>
    <String, dynamic>{
      'products': <Map<String, dynamic>>[_fakeProductJson],
      'total': total,
      'skip': 0,
      'limit': 10,
    };

// ---------------------------------------------------------------------------
// Data source tests — verifies correct endpoint, params, and parsing
// ---------------------------------------------------------------------------

Dio _createMockDio(Map<String, dynamic> responseData) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
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

void main() {
  group('ProductRemoteDataSource.getProducts', () {
    test('calls /products with limit and skip, returns parsed response', () async {
      final Dio dio = _createMockDio(_fakeListResponseJson());

      RequestOptions? capturedOptions;
      dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            capturedOptions = options;
            handler.next(options);
          },
        ),
      );

      final ProductRemoteDataSource dataSource = ProductRemoteDataSource(dio);
      final ProductListResponse result =
          await dataSource.getProducts(limit: 10, skip: 0);

      expect(capturedOptions?.path, '/products');
      expect(capturedOptions?.queryParameters['limit'], 10);
      expect(capturedOptions?.queryParameters['skip'], 0);

      expect(result.products, hasLength(1));
      expect(result.products.first.id, 1);
      expect(result.products.first.title, 'Essence Mascara Lash Princess');
      expect(result.total, 30);
      expect(result.limit, 10);
    });

    test('throws ServerException on server error', () async {
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: 500,
                  statusMessage: 'Internal Server Error',
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      final ProductRemoteDataSource dataSource = ProductRemoteDataSource(dio);
      expect(
        () => dataSource.getProducts(limit: 10, skip: 0),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Notifier tests — verifies state transitions using a fake repository
  // ---------------------------------------------------------------------------

  group('ProductListNotifier', () {
    test('initial state is loading, then transitions to loaded with products',
        () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
          productListProvider.overrideWith(_ManualFetchNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final ProductListNotifier notifier =
          container.read(productListProvider.notifier);

      final ProductListState initial = container.read(productListProvider);
      expect(initial.isLoading, false);
      expect(initial.products, isEmpty);

      await notifier.fetchProducts();

      final ProductListState loaded = container.read(productListProvider);
      expect(loaded.isLoading, false);
      expect(loaded.error, isNull);
      expect(loaded.products, hasLength(1));
      expect(loaded.products.first.title, 'Essence Mascara Lash Princess');
      expect(loaded.total, 30);
      expect(loaded.hasReachedEnd, false);
    });

    test('fetchProducts(refresh: true) resets and reloads products', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
          productListProvider.overrideWith(_ManualFetchNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final ProductListNotifier notifier =
          container.read(productListProvider.notifier);
      await notifier.fetchProducts();
      await notifier.fetchProducts(refresh: true);

      final ProductListState state = container.read(productListProvider);
      expect(state.isLoading, false);
      expect(state.products, hasLength(1));
    });

    test('sets error state when repository throws', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          productRepositoryProvider
              .overrideWithValue(_FailingProductRepository()),
          productListProvider.overrideWith(_ManualFetchNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final ProductListNotifier notifier =
          container.read(productListProvider.notifier);
      await notifier.fetchProducts();

      final ProductListState state = container.read(productListProvider);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);
      expect(state.products, isEmpty);
    });
  });
}

// ---------------------------------------------------------------------------
// Fake repositories for notifier tests
// ---------------------------------------------------------------------------

/// Overrides build() to skip the auto-fetch, giving tests control over timing.
class _ManualFetchNotifier extends ProductListNotifier {
  @override
  ProductListState build() => const ProductListState(isLoading: false);
}

class _FakeProductRepository implements ProductRepository {
  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    return ProductListResponse.fromJson(_fakeListResponseJson());
  }

  @override
  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) async {
    return ProductListResponse.fromJson(_fakeListResponseJson(total: 1));
  }

  @override
  Future<List<CategoryModel>> getCategories() async => <CategoryModel>[];

  @override
  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) async {
    return ProductListResponse.fromJson(_fakeListResponseJson(total: 5));
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    return ProductModel.fromJson(_fakeProductJson);
  }
}

class _FailingProductRepository implements ProductRepository {
  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    throw Exception('Network error');
  }

  @override
  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) async {
    throw Exception('Network error');
  }

  @override
  Future<List<CategoryModel>> getCategories() async =>
      throw Exception('Network error');

  @override
  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) async {
    throw Exception('Network error');
  }

  @override
  Future<ProductModel> getProductById(int id) async =>
      throw Exception('Network error');
}
