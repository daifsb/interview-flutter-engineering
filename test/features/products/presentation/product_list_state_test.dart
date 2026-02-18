import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/products/data/models/category_model.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';
import 'package:interview_flutter/features/products/domain/repositories/product_repository.dart';
import 'package:interview_flutter/features/products/presentation/providers/product_providers.dart';

// ---------------------------------------------------------------------------
// Test #6: ProductListState.copyWith
// ---------------------------------------------------------------------------

void main() {
  group('ProductListState.copyWith', () {
    test('only changes the specified field', () {
      const ProductListState original = ProductListState();
      final ProductListState updated = original.copyWith(isLoading: false);

      expect(updated.isLoading, false);
      expect(updated.products, original.products);
      expect(updated.searchQuery, original.searchQuery);
      expect(updated.selectedCategory, original.selectedCategory);
    });

    test('clears error with error: () => null', () {
      final ProductListState withError = const ProductListState().copyWith(
        error: () => 'something broke',
      );
      expect(withError.error, 'something broke');

      final ProductListState cleared = withError.copyWith(error: () => null);
      expect(cleared.error, isNull);
    });

    test('sets a new error with error: () => message', () {
      final ProductListState state = const ProductListState().copyWith(
        error: () => 'Network timeout',
      );

      expect(state.error, 'Network timeout');
    });

    test('clears selectedCategory with selectedCategory: () => null', () {
      final ProductListState withCategory = const ProductListState().copyWith(
        selectedCategory: () => 'beauty',
      );
      expect(withCategory.selectedCategory, 'beauty');

      final ProductListState cleared = withCategory.copyWith(
        selectedCategory: () => null,
      );
      expect(cleared.selectedCategory, isNull);
    });

    test('preserves nullable fields when not passed', () {
      final ProductListState state = const ProductListState().copyWith(
        error: () => 'err',
        selectedCategory: () => 'cat',
      );

      // copyWith without error/selectedCategory should keep them
      final ProductListState updated = state.copyWith(isLoading: false);
      expect(updated.error, 'err');
      expect(updated.selectedCategory, 'cat');
    });
  });

  // ---------------------------------------------------------------------------
  // Test #7: ProductListNotifier.loadMore guard conditions
  // ---------------------------------------------------------------------------

  group('ProductListNotifier.loadMore', () {
    test('appends products from next page', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          productRepositoryProvider
              .overrideWithValue(_PaginatedFakeRepository()),
          productListProvider.overrideWith(_ManualFetchNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final ProductListNotifier notifier =
          container.read(productListProvider.notifier);

      // Initial fetch (page 1)
      await notifier.fetchProducts();
      expect(container.read(productListProvider).products, hasLength(2));

      // Load more (page 2)
      await notifier.loadMore();
      expect(container.read(productListProvider).products, hasLength(4));
      expect(container.read(productListProvider).hasReachedEnd, false);
    });

    test('is a no-op when hasReachedEnd is true', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          productRepositoryProvider
              .overrideWithValue(_SmallDatasetRepository()),
          productListProvider.overrideWith(_ManualFetchNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final ProductListNotifier notifier =
          container.read(productListProvider.notifier);

      await notifier.fetchProducts();
      final ProductListState afterFetch = container.read(productListProvider);
      expect(afterFetch.hasReachedEnd, true);

      // loadMore should not add anything
      await notifier.loadMore();
      expect(
        container.read(productListProvider).products.length,
        afterFetch.products.length,
      );
    });

    test('is a no-op when already loading more', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          productRepositoryProvider
              .overrideWithValue(_PaginatedFakeRepository()),
          productListProvider.overrideWith(_ManualFetchNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final ProductListNotifier notifier =
          container.read(productListProvider.notifier);
      await notifier.fetchProducts();

      // Simulate isLoadingMore = true by calling loadMore without awaiting
      final Future<void> first = notifier.loadMore();
      // Second call should be a no-op because isLoadingMore is true
      await notifier.loadMore();
      await first;

      // Only one extra page loaded, not two
      expect(container.read(productListProvider).products, hasLength(4));
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _ManualFetchNotifier extends ProductListNotifier {
  @override
  ProductListState build() => const ProductListState(isLoading: false);
}

ProductModel _makeProduct(int id) => ProductModel(
      id: id,
      title: 'Product $id',
      description: '',
      price: 10,
      discountPercentage: 0,
      rating: 4,
      stock: 10,
      brand: 'B',
      category: 'c',
      thumbnail: '',
      images: const <String>[],
    );

/// Returns 2 products per page, total of 10.
class _PaginatedFakeRepository implements ProductRepository {
  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    return ProductListResponse(
      products: <ProductModel>[
        _makeProduct(skip + 1),
        _makeProduct(skip + 2),
      ],
      total: 10,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) async =>
      getProducts(limit: limit, skip: skip);

  @override
  Future<List<CategoryModel>> getCategories() async => <CategoryModel>[];

  @override
  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) async =>
      getProducts(limit: limit, skip: skip);

  @override
  Future<ProductModel> getProductById(int id) async => _makeProduct(id);
}

/// Returns all data in one page so hasReachedEnd becomes true immediately.
class _SmallDatasetRepository implements ProductRepository {
  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    return ProductListResponse(
      products: <ProductModel>[_makeProduct(1)],
      total: 1,
      skip: 0,
      limit: limit,
    );
  }

  @override
  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) async =>
      getProducts(limit: limit, skip: skip);

  @override
  Future<List<CategoryModel>> getCategories() async => <CategoryModel>[];

  @override
  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) async =>
      getProducts(limit: limit, skip: skip);

  @override
  Future<ProductModel> getProductById(int id) async => _makeProduct(id);
}
