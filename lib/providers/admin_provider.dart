import 'package:e_commerce_flutter_app/repositories/product_admin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminRepositoryProvider = Provider((ref) => ProductAdminRepository());

final addProductProvider = FutureProvider.family
    .autoDispose<void, Map<String, dynamic>>((ref, productData) {
      final repo = ref.read(adminRepositoryProvider);

      return repo.addProduct(
        name: productData['name'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        category: productData['category'],
      );
    });
