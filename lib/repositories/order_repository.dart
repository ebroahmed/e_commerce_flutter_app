import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/models/order_model.dart' as my;

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitOrder(my.Order order) async {
    await _firestore.collection('orders').add(order.toMap());
  }
}
