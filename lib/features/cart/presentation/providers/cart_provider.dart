import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';

class CartNotifier extends Notifier<Map<int, CartItem>> {
  @override
  Map<int, CartItem> build() => <int, CartItem>{};

  void addToCart(ProductModel product, {int quantity = 1}) {
    final CartItem? current = state[product.id];
    state = <int, CartItem>{
      ...state,
      product.id: CartItem(
        product: product,
        quantity: (current?.quantity ?? 0) + quantity,
        note: current?.note ?? '',
      ),
    };
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final CartItem? item = state[productId];
    if (item != null) {
      state = <int, CartItem>{
        ...state,
        productId: item.copyWith(quantity: quantity),
      };
    }
  }

  void updateCartItem(int productId, {int? quantity, String? note}) {
    final CartItem? item = state[productId];
    if (item == null) return;
    final int newQty = quantity ?? item.quantity;
    if (newQty <= 0) {
      removeFromCart(productId);
      return;
    }
    state = <int, CartItem>{
      ...state,
      productId: item.copyWith(quantity: newQty, note: note),
    };
  }

  void removeFromCart(int productId) {
    state = Map<int, CartItem>.from(state)..remove(productId);
  }

  void clearCart() {
    state = <int, CartItem>{};
  }
}

final NotifierProvider<CartNotifier, Map<int, CartItem>> cartProvider =
    NotifierProvider<CartNotifier, Map<int, CartItem>>(CartNotifier.new);

// Derived convenience providers

final Provider<int> cartItemCountProvider = Provider<int>((Ref ref) {
  final Map<int, CartItem> cart = ref.watch(cartProvider);
  return cart.values.fold<int>(0, (int sum, CartItem item) => sum + item.quantity);
});

final Provider<double> cartTotalPriceProvider = Provider<double>((Ref ref) {
  final Map<int, CartItem> cart = ref.watch(cartProvider);
  return cart.values.fold<double>(
    0,
    (double sum, CartItem item) => sum + item.totalPrice,
  );
});
