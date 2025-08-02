// Provide the repository
import 'package:e_commerce_flutter_app/models/product_model.dart';
import 'package:e_commerce_flutter_app/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

// Fetch product list
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.fetchProducts();
});
