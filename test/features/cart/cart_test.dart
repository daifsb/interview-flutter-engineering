import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/cart/data/models/cart_item_model.dart';
import 'package:interview_flutter/features/cart/presentation/providers/cart_provider.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';

// ---------------------------------------------------------------------------
// Helper to build a ProductModel with sensible defaults
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

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ---- Test #2: CartItem.totalPrice ----

  group('CartItem.totalPrice', () {
    test('computes price × quantity using discountedPrice', () {
      // defaults: price 100, discountPercentage 10 → discountedPrice = 90
      final ProductModel product = _product();
      const int quantity = 3;
      final CartItem item = CartItem(product: product, quantity: quantity);

      expect(item.totalPrice, 270.0);
    });

    test('is zero when quantity is zero', () {
      final CartItem item = CartItem(product: _product(), quantity: 0);

      expect(item.totalPrice, 0.0);
    });

    test('copyWith updates quantity only', () {
      final CartItem original = CartItem(product: _product(), quantity: 1);
      final CartItem updated = original.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.product, original.product);
    });
  });

  // ---- Test #3: CartNotifier CRUD ----

  group('CartNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('starts with an empty cart', () {
      final Map<int, CartItem> cart = container.read(cartProvider);

      expect(cart, isEmpty);
    });

    test('addToCart inserts a new item', () {
      container.read(cartProvider.notifier).addToCart(_product());

      final Map<int, CartItem> cart = container.read(cartProvider);
      expect(cart, hasLength(1));
      expect(cart[1]!.quantity, 1);
    });

    test('addToCart same product accumulates quantity', () {
      final CartNotifier notifier = container.read(cartProvider.notifier);
      notifier.addToCart(_product(), quantity: 2);
      notifier.addToCart(_product(), quantity: 3);

      expect(container.read(cartProvider)[1]!.quantity, 5);
    });

    test('updateQuantity changes quantity of existing item', () {
      container.read(cartProvider.notifier).addToCart(_product());
      container.read(cartProvider.notifier).updateQuantity(1, 7);

      expect(container.read(cartProvider)[1]!.quantity, 7);
    });

    test('updateQuantity with 0 removes the item', () {
      container.read(cartProvider.notifier).addToCart(_product());
      container.read(cartProvider.notifier).updateQuantity(1, 0);

      expect(container.read(cartProvider), isEmpty);
    });

    test('removeFromCart removes a specific item', () {
      final CartNotifier notifier = container.read(cartProvider.notifier);
      notifier.addToCart(_product());
      notifier.addToCart(_product(id: 2, title: 'Other'));
      notifier.removeFromCart(1);

      final Map<int, CartItem> cart = container.read(cartProvider);
      expect(cart, hasLength(1));
      expect(cart.containsKey(2), true);
    });

    test('clearCart empties everything', () {
      final CartNotifier notifier = container.read(cartProvider.notifier);
      notifier.addToCart(_product());
      notifier.addToCart(_product(id: 2, title: 'Other'));
      notifier.clearCart();

      expect(container.read(cartProvider), isEmpty);
    });
  });

  // ---- Test #4: Derived cart providers ----

  group('Cart derived providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('cartItemCountProvider sums quantities across items', () {
      final CartNotifier notifier = container.read(cartProvider.notifier);
      notifier.addToCart(_product(), quantity: 2);
      notifier.addToCart(_product(id: 2, title: 'B'), quantity: 3);

      expect(container.read(cartItemCountProvider), 5);
    });

    test('cartTotalPriceProvider sums totalPrice across items', () {
      final CartNotifier notifier = container.read(cartProvider.notifier);
      // Product 1: price 100, 10% off → discountedPrice 90, qty 2 → 180
      // Product 1: price 100, 10% off → discountedPrice 90, qty 2 → 180
      notifier.addToCart(_product(), quantity: 2);
      // Product 2: price 50, 0% off → discountedPrice 50, qty 1 → 50
      notifier.addToCart(
        _product(id: 2, title: 'B', price: 50, discountPercentage: 0),
      );

      expect(container.read(cartTotalPriceProvider), 230.0);
    });

    test('derived providers return zero for empty cart', () {
      expect(container.read(cartItemCountProvider), 0);
      expect(container.read(cartTotalPriceProvider), 0.0);
    });
  });
}
