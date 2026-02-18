import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:interview_flutter/features/products/data/models/category_model.dart';
import 'package:interview_flutter/features/products/presentation/providers/product_providers.dart';
import 'package:interview_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('starter app renders product hub shell',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          productListProvider.overrideWith(_StubProductListNotifier.new),
          categoriesProvider.overrideWith(
            (Ref ref) async => <CategoryModel>[],
          ),
        ],
        child: const InterviewStarterApp(),
      ),
    );

    expect(find.text('Product Hub'), findsOneWidget);
  });
}

class _StubProductListNotifier extends ProductListNotifier {
  @override
  ProductListState build() => const ProductListState(isLoading: false);
}
