import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_flutter/features/cart/cart_screen.dart';

import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/products/presentation/screens/product_list_screen/product_list_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String products = 'products';
  static const String productDetail = 'product-detail';
  static const String cart = 'cart';
  static const String favorites = 'favorites';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.products,
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: AppRoutes.productDetail,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return ProductDetailScreen(productId: id);
            },
          ),
          GoRoute(
            path: 'cart',
            name: AppRoutes.cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: 'favorites',
            name: AppRoutes.favorites,
            builder: (context, state) => const _FavoritesPlaceholderScreen(),
          ),
        ],
      ),
    ],
  );
}

class _FavoritesPlaceholderScreen extends StatelessWidget {
  const _FavoritesPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Favorites screen placeholder (Phase 2).'),
      ),
    );
  }
}
