import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:interview_flutter/features/products/data/models/category_model.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';
import 'package:interview_flutter/features/products/domain/repositories/product_repository.dart';
import 'package:interview_flutter/features/products/presentation/providers/product_providers.dart';
import 'package:interview_flutter/features/products/presentation/screens/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Fake data
// ---------------------------------------------------------------------------

Map<String, dynamic> _fakeListResponseJson() => <String, dynamic>{
      'products': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 1,
          'title': 'Essence Mascara',
          'description': 'A test product',
          'price': 9.99,
          'discountPercentage': 7.17,
          'rating': 4.94,
          'stock': 5,
          'brand': 'Essence',
          'category': 'beauty',
          'thumbnail': 'https://cdn.dummyjson.com/thumb.jpg',
          'images': <String>['https://cdn.dummyjson.com/img1.jpg'],
        },
      ],
      'total': 1,
      'skip': 0,
      'limit': 10,
    };

// ---------------------------------------------------------------------------
// Switchable repository: can toggle between failure and success
// ---------------------------------------------------------------------------

class _SwitchableRepository implements ProductRepository {
  bool shouldFail = true;

  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    if (shouldFail) throw Exception('Network error');
    return ProductListResponse.fromJson(_fakeListResponseJson());
  }

  @override
  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  }) async {
    if (shouldFail) throw Exception('Network error');
    return ProductListResponse.fromJson(_fakeListResponseJson());
  }

  @override
  Future<List<CategoryModel>> getCategories() async => <CategoryModel>[];

  @override
  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  }) async {
    if (shouldFail) throw Exception('Network error');
    return ProductListResponse.fromJson(_fakeListResponseJson());
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final List<Map<String, dynamic>> products =
        _fakeListResponseJson()['products']! as List<Map<String, dynamic>>;
    return ProductModel.fromJson(products[0]);
  }
}

/// Starts with an error state so the error UI is visible immediately.
class _ErrorStartNotifier extends ProductListNotifier {
  @override
  ProductListState build() => const ProductListState(
        isLoading: false,
        error: 'Exception: Network error',
      );
}

// ---------------------------------------------------------------------------
// Helper to pump the screen with all required provider overrides
// ---------------------------------------------------------------------------

Future<void> _pumpProductListScreen(
  WidgetTester tester, {
  required SharedPreferences prefs,
  required _SwitchableRepository repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        productRepositoryProvider.overrideWithValue(repository),
        productListProvider.overrideWith(_ErrorStartNotifier.new),
        categoriesProvider.overrideWith(
          (Ref ref) async => <CategoryModel>[],
        ),
      ],
      child: const MaterialApp(home: ProductListScreen()),
    ),
  );
  await tester.pump();
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

  group('ProductListScreen error state', () {
    testWidgets('shows error icon, message, and retry button', (
      WidgetTester tester,
    ) async {
      final _SwitchableRepository repo = _SwitchableRepository();
      await _pumpProductListScreen(tester, prefs: prefs, repository: repo);

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('tapping Retry fetches products and clears error', (
      WidgetTester tester,
    ) async {
      final _SwitchableRepository repo = _SwitchableRepository();
      await _pumpProductListScreen(tester, prefs: prefs, repository: repo);

      // Confirm error state is visible before retrying
      expect(find.text('Retry'), findsOneWidget);

      // Switch repository to success mode, then tap retry
      repo.shouldFail = false;
      await tester.tap(find.text('Retry'));
      // Two pumps: one to fire the callback, one for the async state update
      await tester.pump();
      await tester.pump();

      expect(find.text('Retry'), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text('Essence Mascara'), findsOneWidget);
    });

    testWidgets('tapping Retry while still failing keeps error visible', (
      WidgetTester tester,
    ) async {
      final _SwitchableRepository repo = _SwitchableRepository();
      await _pumpProductListScreen(tester, prefs: prefs, repository: repo);

      // Repo still fails — tap retry
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
