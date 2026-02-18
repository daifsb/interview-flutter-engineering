import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, this.productId});

  final int? productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Product ID: ${productId ?? 'unknown'}\n\n'
              'TODO (Phase 2):\n'
              '- Load selected product details.\n'
              '- Build image carousel.\n'
              '- Show title, brand, description, price, discount, rating, stock.\n'
              '- Implement Add to Favorites action.\n'
              '- Optional: add Add to Cart entry point.\n\n'
              'TODO (Phase 3):\n'
              '- Add quantity selector and Add to Cart action.\n'
              '- Provide smooth UX feedback for cart updates.',
            ),
          ),
        ),
      ),
    );
  }
}
