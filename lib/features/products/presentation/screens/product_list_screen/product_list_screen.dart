import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_flutter/core/initializer/dependencies_initializer.dart';
import 'package:interview_flutter/core/router/app_router.dart';
import 'package:interview_flutter/data/models/all_product_list.dart';
import 'package:interview_flutter/data/models/product_category.dart';
import 'package:interview_flutter/features/cart/cubit/cart_screen_cubit.dart';
import 'package:interview_flutter/features/cart/cubit/cart_screen_state.dart';
import 'package:interview_flutter/features/shared/widgets/loading_overlay.dart';

import 'cubit/product_list_screen_cubit.dart';
import 'cubit/product_list_screen_state.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductListScreenCubit(getIt());
      },
      child: const ProductListScreenView(),
    );
  }
}

class ProductListScreenView extends StatefulWidget {
  const ProductListScreenView({super.key});

  @override
  State<ProductListScreenView> createState() => _ProductListScreenViewState();
}

class _ProductListScreenViewState extends State<ProductListScreenView> {
  late final ProductListScreenCubit _cubit;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProductListScreenCubit>();
    _setupScrollListener();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _cubit.fetchProducts(isRefresh: true);
      await _cubit.fetchCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _cubit.searchProduct(query);
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final state = _cubit.state;
        if (state.selectedCategory == null) {
          _cubit.fetchProducts();
        } else {
          _cubit.fetchProductsByCategory(
            category: state.selectedCategory!.name,
          );
        }
      }
    });
  }

  void _listener(BuildContext context, ProductListScreenState state) {
    switch (state.status) {
      case ProductListScreenStatus.initial:
      case ProductListScreenStatus.loading:
      case ProductListScreenStatus.ready:
        break;

      case ProductListScreenStatus.failure:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListScreenCubit, ProductListScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Store'),
          centerTitle: true,
          elevation: 0,
        ),
        body:
            BlocSelector<ProductListScreenCubit, ProductListScreenState, bool>(
              selector: (state) {
                return state.status.isLoading;
              },
              builder: (context, isLoading) {
                return LoadingOverlay(
                  isLoading: isLoading,
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          _onSearchChanged(value);
                        },
                      ),
                      _buildCategories(),
                      _buildProductList(),
                    ],
                  ),
                );
              },
            ),
        bottomNavigationBar: _buildViewCartButton(),
      ),
    );
  }

  Widget _buildViewCartButton() {
    return BlocSelector<CartScreenCubit, CartScreenState, double>(
      selector: (state) {
        return state.totalPendingPrice;
      },
      builder: (context, price) {
        return SafeArea(
          child: FilledButton(
            onPressed: () {
              context.pushNamed(AppRoutes.cart);
            },
            child: Text('${price.toStringAsFixed(2)} View Cart'),
          ),
        );
      },
    );
  }

  Widget _buildCategories() {
    return BlocSelector<
      ProductListScreenCubit,
      ProductListScreenState,
      (List<ProductCategory?>, ProductCategory?)
    >(
      selector: (state) {
        return (state.categories, state.selectedCategory);
      },
      builder: (context, state) {
        final (categories, selectedCategory) = state;
        if (categories.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 50,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isAllChip = category?.slug == 'all';
              final isSelected =
                  selectedCategory == category ||
                  (selectedCategory == null && isAllChip);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: ChoiceChip(
                  label: Text(category?.name ?? 'N/A'),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) {
                      _cubit.selectCategory(category);
                    }
                  },
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    return BlocSelector<
      ProductListScreenCubit,
      ProductListScreenState,
      List<Product>?
    >(
      selector: (state) => state.products?.products,
      builder: (context, products) {
        if (products == null || products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final bool showHeader =
                  index == 0 ||
                  products[index - 1].category != product.category;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader) ...[
                    const SizedBox(height: 24),
                    _buildSectionHeader(product.category),
                    const Divider(),
                    const SizedBox(height: 8),
                  ],
                  _buildProductItem(product),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(thickness: 0.5),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String categoryName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          categoryName.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      ],
    );
  }

  Widget _buildProductItem(Product product) {
    return InkWell(
      onTap: () {
        context.read<CartScreenCubit>().addProduct(product);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.thumbnail,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 100, height: 100, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '★ ${product.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
