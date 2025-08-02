import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/models/product_model.dart';

class ProductRepository {
  final CollectionReference productsRef = FirebaseFirestore.instance.collection(
    'products',
  );

  Future<List<Product>> fetchProducts() async {
    final snapshot = await productsRef.get();
    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> addProduct(Product product) async {
    await productsRef.add(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await productsRef.doc(id).delete();
  }

  Future<void> updateProduct(Product product) async {
    await productsRef.doc(product.id).update(product.toMap());
  }
}
