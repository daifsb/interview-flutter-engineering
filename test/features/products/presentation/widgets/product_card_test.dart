import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';
import 'package:interview_flutter/features/products/presentation/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Shared fixtures
// ---------------------------------------------------------------------------

const ProductModel _discountedProduct = ProductModel(
  id: 1,
  title: 'Mascara Lash Princess',
  description: 'Popular mascara',
  price: 9.99,
  discountPercentage: 7.17,
  rating: 4.94,
  stock: 5,
  brand: 'Essence',
  category: 'beauty',
  thumbnail: 'https://cdn.dummyjson.com/thumb.jpg',
  images: <String>['https://cdn.dummyjson.com/img1.jpg'],
);

const ProductModel _noDiscountProduct = ProductModel(
  id: 2,
  title: 'Full Price Item',
  description: 'No discount',
  price: 50.0,
  discountPercentage: 0,
  rating: 3.5,
  stock: 12,
  brand: 'Brand',
  category: 'electronics',
  thumbnail: 'https://cdn.dummyjson.com/thumb2.jpg',
  images: <String>[],
);

/// Stub notifier that returns a fixed set without touching SharedPreferences.
class _StubFavoritesNotifier extends FavoritesNotifier {
  _StubFavoritesNotifier(this._ids);
  final Set<int> _ids;

  @override
  Set<int> build() => _ids;
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Future<void> _pumpProductCard(
  WidgetTester tester, {
  required ProductModel product,
  Set<int> favoriteIds = const <int>{},
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        favoritesProvider.overrideWith(() => _StubFavoritesNotifier(favoriteIds)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 350,
            child: ProductCard(
              product: product,
              onTap: () {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ProductCard', () {
    testWidgets('renders title, discounted price, and rating', (
      WidgetTester tester,
    ) async {
      await _pumpProductCard(tester, product: _discountedProduct);

      expect(find.text('Mascara Lash Princess'), findsOneWidget);
      // discountedPrice = 9.99 * (1 - 0.0717) ≈ 9.27
      expect(find.textContaining('9.27'), findsOneWidget);
      expect(find.textContaining('4.9'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('shows discount badge and original price when discounted', (
      WidgetTester tester,
    ) async {
      await _pumpProductCard(tester, product: _discountedProduct);

      expect(find.textContaining('-7%'), findsOneWidget);
      expect(find.textContaining('9.99'), findsOneWidget);
    });

    testWidgets('hides discount badge when discountPercentage is 0', (
      WidgetTester tester,
    ) async {
      await _pumpProductCard(tester, product: _noDiscountProduct);

      expect(find.textContaining('-'), findsNothing);
      expect(find.textContaining('50.00'), findsWidgets);
    });

    testWidgets('shows outline heart when product is not favorited', (
      WidgetTester tester,
    ) async {
      await _pumpProductCard(tester, product: _discountedProduct);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('shows filled heart when product is favorited', (
      WidgetTester tester,
    ) async {
      await _pumpProductCard(
        tester,
        product: _discountedProduct,
        favoriteIds: <int>{_discountedProduct.id},
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });
  });
}
