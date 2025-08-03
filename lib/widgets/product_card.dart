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
      data: (wishlistIds) {
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
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),

                //  Product Info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 105, 95, 5),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          final repo = ref.read(wishlistRepoProvider);
                          final productMap = {
                            'id': product.id,
                            'name': product.name,
                            'price': product.price,
                            'imageUrl': product.imageUrl,
                            'category': product.category,
                          };
                          if (user != null) {
                            if (isWishlisted) {
                              await repo.removeFromWishlist(
                                user.uid,
                                product.id,
                              );
                            } else {
                              await repo.addToWishlist(user.uid, productMap);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => const Icon(Icons.error),
    );
  }
}
