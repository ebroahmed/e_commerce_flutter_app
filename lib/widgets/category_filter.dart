// lib/widgets/category_filter.dart
import 'package:e_commerce_flutter_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const categories = [
  'All',
  'Shoes',
  'Electronics',
  'Accessories',
  'Fashion',
  'Computers',
];

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          final isSelected =
              selectedCategory == null && category == 'All' ||
              selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).state =
                    category == 'All' ? null : category;
              },
            ),
          );
        },
      ),
    );
  }
}
