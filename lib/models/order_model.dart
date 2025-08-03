import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/models/cart_item_model.dart';

class Order {
  final String userId;
  final List<CartItem> items;
  final double total;
  final String address;
  final Timestamp timestamp;

  Order({
    required this.userId,
    required this.items,
    required this.total,
    required this.address,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'total': total,
      'timestamp': timestamp,
      'products': items
          .map(
            (e) => {
              'id': e.product.id,
              'name': e.product.name,
              'price': e.product.price,
              'quantity': e.quantity,
            },
          )
          .toList(),
    };
  }
}
