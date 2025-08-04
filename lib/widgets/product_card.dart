import 'package:e_commerce_flutter_app/models/product_model.dart';
import 'package:e_commerce_flutter_app/providers/wishlist_provider.dart';
import 'package:e_commerce_flutter_app/screens/product_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistStreamProvider);
    final user = FirebaseAuth.instance.currentUser;

    return wishlist.when(
      data: (wishlistItems) {
        final wishlistIds = wishlistItems.map((item) => item['id']).toList();
        final isWishlisted = wishlistIds.contains(product.id);

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Card(
            color: Theme.of(context).colorScheme.onPrimary,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed-height Image
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  //  Product Name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  //  Price and Wishlist Icon in Row
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 105, 95, 5),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            if (user == null) return;

                            final repo = ref.read(wishlistRepoProvider);
                            final productMap = {
                              'id': product.id,
                              'name': product.name,
                              'price': product.price,
                              'imageUrl': product.imageUrl,
                              'category': product.category,
                            };

                            if (isWishlisted) {
                              await repo.removeFromWishlist(
                                user.uid,
                                product.id,
                              );
                            } else {
                              await repo.addToWishlist(user.uid, productMap);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Icon(Icons.error),
    );
  }
}
