import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/product_category.dart';
import 'package:interview_flutter/domain/core/result.dart';
import 'package:interview_flutter/domain/repositories/products_repository.dart';
import 'package:interview_flutter/features/products/presentation/screens/product_list_screen/cubit/product_list_screen_state.dart';

class ProductListScreenCubit extends Cubit<ProductListScreenState> {
  final ProductsRepository _productsRepository;
  ProductListScreenCubit(this._productsRepository)
    : super(const ProductListScreenState());

  Future<void> fetchProducts({bool isRefresh = false}) async {
    // If refreshing, reset skip to 0. Otherwise, use state.skip
    final nextSkip = isRefresh ? 0 : state.skip;

    // Optional: Don't fetch if already loading
    if (state.status == ProductListScreenStatus.loading && !isRefresh) return;

    emit(state.copyWith(status: ProductListScreenStatus.loading));

    final response = await _productsRepository.getAllProducts(
      limit: state.limit,
      skip: nextSkip,
    );

    switch (response) {
      case Success(value: final newList):
        final List<Product> updatedProducts = isRefresh
            ? newList.products
            : [...(state.products?.products ?? []), ...newList.products];

        emit(
          state.copyWith(
            status: ProductListScreenStatus.ready,
            products: AllProductList(
              products: updatedProducts,
              total: newList.total,
              skip: newList.skip,
              limit: newList.limit,
            ),
            skip: nextSkip + state.limit,
          ),
        );
        break;
      case Failure(error: final error):
        emit(state.failure(error));
        break;
    }
  }

  Future<void> fetchCategories() async {
    emit(state.loading());
    final response = await _productsRepository.getProductCategories();
    switch (response) {
      case Success(value: final categories):
        const allCategory = ProductCategory(slug: 'all', name: 'All', url: '');
        final updatedCategories = [allCategory, ...categories];
        emit(state.ready(categories: updatedCategories));
      case Failure(error: final error):
        emit(state.failure(error));
    }
  }

  Future<void> fetchProductsByCategory({
    required String category,
    bool isRefresh = false,
  }) async {
    emit(state.loading());
    final nextSkip = isRefresh ? 0 : state.skip;
    final response = await _productsRepository.getProductsByCategory(
      category,
      limit: state.limit,
      skip: nextSkip,
    );
    switch (response) {
      case Success(value: final newList):
        final List<Product> updatedProducts = isRefresh
            ? newList.products
            : [...(state.products?.products ?? []), ...newList.products];

        emit(
          state.copyWith(
            status: ProductListScreenStatus.ready,
            products: AllProductList(
              products: updatedProducts,
              total: newList.total,
              skip: newList.skip,
              limit: newList.limit,
            ),
            skip: nextSkip + state.limit,
          ),
        );
        break;
      case Failure(error: final error):
        emit(state.failure(error));
        break;
    }
  }

  Future<void> searchProduct(String text) async {
    emit(state.loading());
    final response = await _productsRepository.searchProducts(text);
    switch (response) {
      case Success(value: final newList):
        emit(state.ready(products: newList));
      case Failure(error: final error):
        emit(state.failure(error));
    }
  }

  Future<void> selectCategory(ProductCategory? category) async {
    if (category == null || category == state.selectedCategory) return;
    emit(state.copyWith(selectedCategory: category, skip: 0));

    if (category.slug == 'all') {
      await fetchProducts(isRefresh: true);
    } else {
      await fetchProductsByCategory(category: category.slug, isRefresh: true);
    }
  }
}
