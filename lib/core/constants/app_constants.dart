class AppConstants {
  AppConstants._();

  static const String appName = 'Product Hub Interview';
  static const String baseUrl = 'https://dummyjson.com';

  static const int defaultLimit = 10;
  static const int searchDebounceMs = 400;
  static const int nextPageTriggerThreshold = 2;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const String favoritesStorageKey = 'favorite_product_ids';
}
