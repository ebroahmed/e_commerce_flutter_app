import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToWishlist(
    String userId,
    Map<String, dynamic> product,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(product['id'])
        .set(product);
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getWishlist(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }
}
