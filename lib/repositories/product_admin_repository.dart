import 'package:cloud_firestore/cloud_firestore.dart';

class ProductAdminRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
  }) async {
    final productData = {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('products').add(productData);
  }
}
