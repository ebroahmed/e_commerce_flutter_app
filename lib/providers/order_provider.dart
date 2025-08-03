import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/models/order_model.dart' as my;
import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository());

final pastOrdersProvider = StreamProvider<List<my.Order>>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return authAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();

      return FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return my.Order(
                userId: data['userId'],
                items: [], // optionally fill this later
                total: (data['total'] ?? 0).toDouble(),
                address: data['address'] ?? '',
                timestamp: data['timestamp'],
              );
            }).toList();
          });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
