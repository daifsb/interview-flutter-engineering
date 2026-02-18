import 'package:equatable/equatable.dart';

import '../../../products/data/models/product_model.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.quantity,
    this.note = '',
  });

  final ProductModel product;
  final int quantity;
  final String note;

  double get totalPrice => product.discountedPrice * quantity;

  CartItem copyWith({int? quantity, String? note}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [product, quantity, note];
}
