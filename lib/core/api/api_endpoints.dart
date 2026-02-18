class ApiEndpoints {
  ApiEndpoints._();

  static const String products = '/products';
  static const String searchProducts = '/products/search';
  static const String categories = '/products/categories';

  static String productsByCategory(String category) =>
      '/products/category/$category';
}
