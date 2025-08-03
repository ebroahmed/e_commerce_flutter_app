import 'package:e_commerce_flutter_app/providers/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'My Wishlist',
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: wishlist.when(
        data: (wishlistItems) {
          if (wishlistItems.isEmpty) {
            return Center(
              child: Text(
                "No items in wishlist ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final product = wishlistItems[index];

              return Card(
                elevation: 4,
                color: Theme.of(context).colorScheme.onPrimary,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['imageUrl'],
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${product['category']}  •  \$${product['price']}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: const Color.fromARGB(255, 109, 23, 17),
                    ),
                    onPressed: () {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        ref
                            .read(wishlistRepoProvider)
                            .removeFromWishlist(user.uid, product['id']);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
