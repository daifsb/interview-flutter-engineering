import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';

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
            builder: (context, state) => const FavoritesScreen(),
          ),
        ],
      ),
    ],
  );
}
