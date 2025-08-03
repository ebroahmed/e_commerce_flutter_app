import 'package:e_commerce_flutter_app/repositories/wishlist_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistRepoProvider = Provider((ref) => WishlistRepository());

final wishlistStreamProvider = StreamProvider<List<String>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();
  final repo = ref.read(wishlistRepoProvider);

  return repo
      .getWishlist(user.uid)
      .map((items) => items.map((item) => item['id'] as String).toList());
});
