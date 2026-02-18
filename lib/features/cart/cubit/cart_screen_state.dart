import 'package:equatable/equatable.dart';
import 'package:interview_flutter/data/models/cart_item.dart';

enum CartScreenStatus {
  initial,
  loading,
  ready,
  failure,
  ;

  bool get isLoading => this == CartScreenStatus.loading;
}

class CartScreenState extends Equatable {
  final CartScreenStatus status;
  final List<CartItem> items;

  const CartScreenState({
    this.status = CartScreenStatus.initial,
    this.items = const [],
  });

  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAllPrice =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  double get totalPendingPrice => items
      .where((item) => !item.hasSent)
      .fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  double get totalSentPrice => items
      .where((item) => item.hasSent)
      .fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  @override
  List<Object?> get props => [
    status,
    items,
  ];

  CartScreenState copyWith({
    CartScreenStatus? status,
    List<CartItem>? items,
  }) {
    return CartScreenState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  CartScreenState loading() {
    return copyWith(
      status: CartScreenStatus.loading,
    );
  }

  CartScreenState ready() {
    return copyWith(
      status: CartScreenStatus.ready,
    );
  }
}
