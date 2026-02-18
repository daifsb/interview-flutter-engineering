import 'package:equatable/equatable.dart';
import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/product_category.dart';
import 'package:interview_flutter/domain/core/app_error.dart';

enum ProductListScreenStatus {
  initial,
  loading,
  ready,
  failure,
  ;

  bool get isLoading => this == ProductListScreenStatus.loading;
}

class ProductListScreenState extends Equatable {
  final ProductListScreenStatus status;
  final int limit;
  final int skip;
  final List<ProductCategory?> categories;
  final ProductCategory? selectedCategory;
  final AllProductList? products;

  final AppError? error;

  const ProductListScreenState({
    this.status = ProductListScreenStatus.initial,
    this.limit = 10,
    this.skip = 0,
    this.categories = const [],
    this.selectedCategory,
    this.products,
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    limit,
    skip,
    categories,
    selectedCategory,
    products,
    error,
  ];

  ProductListScreenState copyWith({
    ProductListScreenStatus? status,
    int? limit,
    int? skip,
    List<ProductCategory?>? categories,
    ProductCategory? selectedCategory,
    AllProductList? products,
    AppError? error,
  }) {
    return ProductListScreenState(
      status: status ?? this.status,
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      error: error ?? this.error,
    );
  }

  ProductListScreenState loading() {
    return copyWith(
      status: ProductListScreenStatus.loading,
    );
  }

  ProductListScreenState ready({
    AllProductList? products,
    List<ProductCategory?>? categories,
  }) {
    return copyWith(
      status: ProductListScreenStatus.ready,
      products: products,
      categories: categories,
    );
  }

  ProductListScreenState failure(AppError error) {
    return copyWith(
      status: ProductListScreenStatus.failure,
      error: error,
    );
  }
}
