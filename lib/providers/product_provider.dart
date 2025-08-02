// Provide the repository
import 'package:e_commerce_flutter_app/models/product_model.dart';
import 'package:e_commerce_flutter_app/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

// StateProvider for selected category
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// StateProvider for search term
final searchTermProvider = StateProvider<String>((ref) => '');

// Main filtered product list
final filteredProductListProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final search = ref.watch(searchTermProvider).toLowerCase();

  final allProducts = await repo.fetchProducts();

  return allProducts.where((product) {
    final matchesCategory = category == null || product.category == category;
    final matchesSearch = product.name.toLowerCase().contains(search);
    return matchesCategory && matchesSearch;
  }).toList();
});
