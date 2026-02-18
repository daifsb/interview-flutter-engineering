import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category_model.dart';
import '../providers/product_providers.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CategoryModel>> categoriesAsync =
        ref.watch(categoriesProvider);
    final String? selectedCategory =
        ref.watch(productListProvider.select((ProductListState s) => s.selectedCategory));

    return categoriesAsync.when(
      data: (List<CategoryModel> categories) {
        return SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length + 1,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                final bool isSelected = selectedCategory == null;
                return FilterChip(
                  label: const Text('All'),
                  selected: isSelected,
                  onSelected: (bool _) {
                    ref.read(productListProvider.notifier).setCategory(null);
                  },
                );
              }
              final CategoryModel category = categories[index - 1];
              final bool isSelected = selectedCategory == category.slug;
              return FilterChip(
                label: Text(category.name),
                selected: isSelected,
                onSelected: (bool _) {
                  ref
                      .read(productListProvider.notifier)
                      .setCategory(isSelected ? null : category.slug);
                },
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 48,
        child: Center(child: LinearProgressIndicator()),
      ),
      error: (Object error, StackTrace stack) => const SizedBox.shrink(),
    );
  }
}
