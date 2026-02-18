import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

// ---------------------------------------------------------------------------
// DI providers
// ---------------------------------------------------------------------------

final Provider<ProductRemoteDataSource> productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((Ref ref) {
  return ProductRemoteDataSource(ApiClient.instance.dio);
});

final Provider<ProductRepository> productRepositoryProvider =
    Provider<ProductRepository>((Ref ref) {
  return ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider));
});

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

final FutureProvider<List<CategoryModel>> categoriesProvider =
    FutureProvider<List<CategoryModel>>((Ref ref) async {
  final ProductRepository repository = ref.watch(productRepositoryProvider);
  return repository.getCategories();
});

// ---------------------------------------------------------------------------
// Product detail
// ---------------------------------------------------------------------------

final productDetailProvider =
    FutureProvider.autoDispose
        .family<ProductModel, int>((Ref ref, int id) async {
  final ProductRepository repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});

// ---------------------------------------------------------------------------
// Product list state + notifier
// ---------------------------------------------------------------------------

class ProductListState extends Equatable {
  const ProductListState({
    this.products = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.error,
    this.total = 0,
    this.searchQuery = '',
    this.selectedCategory,
    this.hasReachedEnd = false,
  });

  final List<ProductModel> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int total;
  final String searchQuery;
  final String? selectedCategory;
  final bool hasReachedEnd;

  ProductListState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? error,
    int? total,
    String? searchQuery,
    String? Function()? selectedCategory,
    bool? hasReachedEnd,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
      total: total ?? this.total,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
        products,
        isLoading,
        isLoadingMore,
        error,
        total,
        searchQuery,
        selectedCategory,
        hasReachedEnd,
      ];
}

class ProductListNotifier extends Notifier<ProductListState> {
  @override
  ProductListState build() {
    Future<void>.microtask(() => fetchProducts());
    return const ProductListState();
  }

  ProductRepository get _repository => ref.read(productRepositoryProvider);

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        products: const [],
        isLoading: true,
        error: () => null,
        hasReachedEnd: false,
      );
    } else {
      state = state.copyWith(isLoading: true, error: () => null);
    }

    try {
      final ProductListResponse response = await _getProducts(skip: 0);
      state = state.copyWith(
        products: response.products,
        total: response.total,
        isLoading: false,
        hasReachedEnd: response.products.length >= response.total,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: () => e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);

    try {
      final ProductListResponse response = await _getProducts(
        skip: state.products.length,
      );
      final List<ProductModel> allProducts = [
        ...state.products,
        ...response.products,
      ];
      state = state.copyWith(
        products: allProducts,
        total: response.total,
        isLoadingMore: false,
        hasReachedEnd: allProducts.length >= response.total,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: () => e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      selectedCategory: () => null,
    );
    fetchProducts(refresh: true);
  }

  void setCategory(String? category) {
    state = state.copyWith(
      selectedCategory: () => category,
      searchQuery: '',
    );
    fetchProducts(refresh: true);
  }

  Future<ProductListResponse> _getProducts({required int skip}) {
    const int limit = AppConstants.defaultLimit;
    if (state.searchQuery.isNotEmpty) {
      return _repository.searchProducts(
        state.searchQuery,
        limit: limit,
        skip: skip,
      );
    } else if (state.selectedCategory != null) {
      return _repository.getProductsByCategory(
        state.selectedCategory!,
        limit: limit,
        skip: skip,
      );
    } else {
      return _repository.getProducts(limit: limit, skip: skip);
    }
  }
}

final NotifierProvider<ProductListNotifier, ProductListState>
    productListProvider =
    NotifierProvider<ProductListNotifier, ProductListState>(
  ProductListNotifier.new,
);
