import 'package:equatable/equatable.dart';

import '../../../products/data/models/product_model.dart';

class CartItem extends Equatable {
  const CartItem({required this.product, required this.quantity});

  final ProductModel product;
  final int quantity;

  double get totalPrice => product.discountedPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
