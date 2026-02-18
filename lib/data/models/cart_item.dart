import 'package:equatable/equatable.dart';
import 'package:interview_flutter/data/models/all_product_list.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final bool hasSent;
  final String remark;

  const CartItem({
    required this.product,
    this.quantity = 1,
    this.hasSent = false,
    this.remark = '',
  });

  CartItem copyWith({
    int? quantity,
    bool? hasSent,
    String? remark,
  }) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      hasSent: hasSent ?? this.hasSent,
      remark: remark ?? this.remark,
    );
  }

  @override
  List<Object?> get props => [
    product,
    quantity,
    hasSent,
    remark,
  ];
}
