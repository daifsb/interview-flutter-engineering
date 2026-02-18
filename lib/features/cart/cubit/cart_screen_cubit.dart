import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/cart_item.dart';

import 'cart_screen_state.dart';

class CartScreenCubit extends Cubit<CartScreenState> {
  CartScreenCubit() : super(const CartScreenState());

  void addProduct(Product product) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(product: product));
    }
    emit(state.copyWith(items: items));
  }

  void removeProduct(Product product) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
    }
    emit(state.copyWith(items: items));
  }

  void markAsSent() {
    final updatedItems = state.items
        .map((item) => item.copyWith(hasSent: true))
        .toList();
    emit(state.copyWith(items: updatedItems, status: CartScreenStatus.ready));
  }

  void deleteProductCompletely(Product product) {
    final List<CartItem> updatedItems = List<CartItem>.from(state.items);
    updatedItems.removeWhere((item) => item.product.id == product.id);
    emit(
      state.copyWith(
        items: updatedItems,
        status: CartScreenStatus.ready,
      ),
    );
  }

  void updateRemark(Product product, String remark) {
    final List<CartItem> updatedItems = List<CartItem>.from(state.items);
    final index = updatedItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      updatedItems[index] = updatedItems[index].copyWith(remark: remark);
      emit(state.copyWith(items: updatedItems, status: CartScreenStatus.ready));
    }
  }
}
