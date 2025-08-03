// lib/screens/checkout_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/models/order_model.dart' as my;
import 'package:e_commerce_flutter_app/providers/cart_provider.dart';
import 'package:e_commerce_flutter_app/providers/order_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Address
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Shipping Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Payment (mock)
            const Text('Payment Method: Credit Card (Mock)'),
            const SizedBox(height: 20),

            // Order Summary
            Expanded(
              child: ListView(
                children: [
                  ...cartItems.map(
                    (item) => ListTile(
                      title: Text('${item.product.name} x${item.quantity}'),
                      trailing: Text(
                        '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Total'),
                    trailing: Text('\$${total.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Place Order"),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You must be logged in")),
                    );
                    return;
                  }

                  if (addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter your address"),
                      ),
                    );
                    return;
                  }

                  final order = my.Order(
                    userId: user.uid,
                    items: cartItems,
                    total: total,
                    address: addressController.text.trim(),
                    timestamp: Timestamp.now(),
                  );

                  try {
                    await ref.read(orderRepositoryProvider).submitOrder(order);

                    // Clear cart
                    ref.read(cartProvider.notifier).clearCart();

                    // Success
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order placed successfully!"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error placing order: $e")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
