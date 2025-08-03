import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/repositories/wishlist_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistRepoProvider = Provider((ref) => WishlistRepository());

final wishlistStreamProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) {
  final user = ref.watch(authStateProvider).value;

  if (user == null) return const Stream.empty();
  return ref.read(wishlistRepoProvider).getWishlist(user.uid);
});
