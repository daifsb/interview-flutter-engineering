import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Hub'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Interview Starter - Product List'),
            SizedBox(height: 12),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'TODO (Phase 1):\n'
                  '- Set up chosen state management solution.\n'
                  '- Fetch products from GET /products?limit=10&skip=0.\n'
                  '- Show loading state using shimmer placeholders.\n'
                  '- Show error state with a retry button.\n'
                  '- Render product cards (image, title, price, discount, rating).\n'
                  '- Navigate to product detail when tapping a card.\n\n'
                  'TODO (Phase 2):\n'
                  '- Add debounced search using GET /products/search?q={query}.\n'
                  '- Add category chips using GET /products/categories and GET /products/category/{category}.\n'
                  '- Add favorites indicator and persistence.\n\n'
                  'TODO (Phase 3):\n'
                  '- Add infinite scroll pagination and pull-to-refresh.\n'
                  '- Handle no-more-items state and footer loading spinner.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
