import 'package:e_commerce_flutter_app/providers/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: wishlist.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(items[i]['title']),
            subtitle: Text('${items[i]['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  ref
                      .read(wishlistRepoProvider)
                      .removeFromWishlist(userId, items[i]['id']);
                }
              },
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
