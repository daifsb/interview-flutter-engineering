import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:interview_flutter/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Stub notifier that returns a fixed set without touching SharedPreferences.
// ---------------------------------------------------------------------------

class _StubFavoritesNotifier extends FavoritesNotifier {
  _StubFavoritesNotifier(this._ids);
  final Set<int> _ids;

  @override
  Set<int> build() => _ids;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  group('FavoritesScreen empty state', () {
    testWidgets('shows empty icon and message when no favorites', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            favoritesProvider
                .overrideWith(() => _StubFavoritesNotifier(const <int>{})),
            favoriteProductsProvider.overrideWith(
              (Ref ref) async => <ProductModel>[],
            ),
          ],
          child: const MaterialApp(home: FavoritesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('No favorites yet'), findsOneWidget);
      expect(
        find.text('Tap the heart icon on any product to add it here'),
        findsOneWidget,
      );
    });
  });

  group('FavoritesScreen loading state', () {
    testWidgets('shows CircularProgressIndicator while loading', (
      WidgetTester tester,
    ) async {
      final Completer<List<ProductModel>> completer =
          Completer<List<ProductModel>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            favoritesProvider
                .overrideWith(() => _StubFavoritesNotifier(const <int>{})),
            favoriteProductsProvider.overrideWith(
              (Ref ref) => completer.future,
            ),
          ],
          child: const MaterialApp(home: FavoritesScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(<ProductModel>[]);
      await tester.pumpAndSettle();
    });
  });

  group('FavoritesScreen error state', () {
    testWidgets('shows error icon, message, and Retry button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            favoritesProvider
                .overrideWith(() => _StubFavoritesNotifier(const <int>{})),
            favoriteProductsProvider.overrideWith(
              (Ref ref) async => throw Exception('Failed to load'),
            ),
          ],
          child: const MaterialApp(home: FavoritesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Failed to load'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
