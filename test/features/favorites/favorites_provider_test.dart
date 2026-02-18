import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/core/constants/app_constants.dart';
import 'package:interview_flutter/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FavoritesNotifier', () {
    late SharedPreferences prefs;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('starts with empty set when no saved favorites', () {
      final Set<int> favorites = container.read(favoritesProvider);

      expect(favorites, isEmpty);
    });

    test('toggleFavorite adds an ID', () async {
      await container.read(favoritesProvider.notifier).toggleFavorite(42);

      final Set<int> favorites = container.read(favoritesProvider);
      expect(favorites, contains(42));
    });

    test('toggleFavorite twice removes the ID', () async {
      final FavoritesNotifier notifier =
          container.read(favoritesProvider.notifier);
      await notifier.toggleFavorite(42);
      await notifier.toggleFavorite(42);

      final Set<int> favorites = container.read(favoritesProvider);
      expect(favorites, isNot(contains(42)));
    });

    test('toggleFavorite persists IDs to SharedPreferences', () async {
      await container.read(favoritesProvider.notifier).toggleFavorite(1);
      await container.read(favoritesProvider.notifier).toggleFavorite(2);

      final List<String>? stored =
          prefs.getStringList(AppConstants.favoritesStorageKey);
      expect(stored, isNotNull);
      expect(stored!.map(int.parse).toSet(), equals(<int>{1, 2}));
    });

    test('loads pre-seeded favorites from SharedPreferences', () async {
      // Seed prefs before creating a new container
      await prefs.setStringList(
        AppConstants.favoritesStorageKey,
        <String>['10', '20', '30'],
      );

      final ProviderContainer seeded = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(seeded.dispose);

      final Set<int> favorites = seeded.read(favoritesProvider);
      expect(favorites, equals(<int>{10, 20, 30}));
    });
  });
}
