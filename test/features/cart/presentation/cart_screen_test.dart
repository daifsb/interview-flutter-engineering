import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/cart/presentation/providers/cart_provider.dart';
import 'package:interview_flutter/features/cart/presentation/screens/cart_screen.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

ProductModel _product({
  int id = 1,
  String title = 'Test Product',
  double price = 100,
  double discountPercentage = 10,
}) {
  return ProductModel(
    id: id,
    title: title,
    description: 'description',
    price: price,
    discountPercentage: discountPercentage,
    rating: 4.0,
    stock: 10,
    brand: 'Brand',
    category: 'category',
    thumbnail: '',
    images: const <String>[],
  );
}

Future<void> _pumpCartScreen(
  WidgetTester tester, {
  List<ProductModel> products = const [],
}) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: CartScreen()),
    ),
  );

  if (products.isNotEmpty) {
    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(CartScreen)),
    );
    for (final product in products) {
      container.read(cartProvider.notifier).addToCart(product);
    }
    await tester.pump();
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('CartScreen empty state', () {
    testWidgets('shows empty cart icon and message', (
      WidgetTester tester,
    ) async {
      await _pumpCartScreen(tester);

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('does not show Clear button or Checkout', (
      WidgetTester tester,
    ) async {
      await _pumpCartScreen(tester);

      expect(find.text('Clear'), findsNothing);
      expect(find.text('Checkout'), findsNothing);
    });
  });

  group('CartScreen with items', () {
    testWidgets('shows item title, quantity, total, and action buttons', (
      WidgetTester tester,
    ) async {
      await _pumpCartScreen(tester, products: [_product()]);

      expect(find.text('Test Product'), findsOneWidget);
      // price 100, 10% off → 90.00, qty 1 → ×1  ·  $90.00
      expect(find.textContaining('×1'), findsOneWidget);
      expect(find.textContaining('90.00'), findsWidgets);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('shows multiple items when cart has several products', (
      WidgetTester tester,
    ) async {
      await _pumpCartScreen(tester, products: [
        _product(),
        _product(id: 2, title: 'Second Product', price: 50),
      ]);

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Second Product'), findsOneWidget);
    });
  });
}
