import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/presentation/providers/product_providers.dart';

// ---------------------------------------------------------------------------
// SharedPreferences — override in ProviderScope at app startup
// ---------------------------------------------------------------------------

final Provider<SharedPreferences> sharedPreferencesProvider =
    Provider<SharedPreferences>((Ref ref) {
  throw UnimplementedError('SharedPreferences not initialised');
});

// ---------------------------------------------------------------------------
// Favorites notifier — persists a Set<int> of product IDs
// ---------------------------------------------------------------------------

class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    return _loadFromPrefs();
  }

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  Set<int> _loadFromPrefs() {
    final List<String> ids =
        _prefs.getStringList(AppConstants.favoritesStorageKey) ?? <String>[];
    return ids.map(int.parse).toSet();
  }

  Future<void> toggleFavorite(int productId) async {
    final Set<int> updated = Set<int>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;
    await _prefs.setStringList(
      AppConstants.favoritesStorageKey,
      updated.map((int id) => id.toString()).toList(),
    );
  }

  bool isFavorite(int productId) => state.contains(productId);
}

final NotifierProvider<FavoritesNotifier, Set<int>> favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<int>>(FavoritesNotifier.new);

// ---------------------------------------------------------------------------
// Derived provider: list of favourite ProductModels
// ---------------------------------------------------------------------------

final favoriteProductsProvider =
    FutureProvider.autoDispose<List<ProductModel>>((Ref ref) async {
  final Set<int> favoriteIds = ref.watch(favoritesProvider);
  if (favoriteIds.isEmpty) return <ProductModel>[];

  final repository = ref.watch(productRepositoryProvider);
  final List<ProductModel> products = await Future.wait(
    favoriteIds.map((int id) => repository.getProductById(id)),
  );
  return products;
});
