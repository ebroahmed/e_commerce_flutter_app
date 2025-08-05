// lib/screens/checkout_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/models/order_model.dart' as my;
import 'package:e_commerce_flutter_app/providers/cart_provider.dart';
import 'package:e_commerce_flutter_app/providers/order_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Checkout",
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Address
            TextFormField(
              controller: addressController,
              style: TextStyle(
                decorationColor: Theme.of(context).colorScheme.surface,
                color: Theme.of(context).colorScheme.primary,
              ),
              decoration: InputDecoration(
                labelText: 'Shipping Address',
                labelStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.7),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 25),

            // Payment (mock)
            Text(
              'Payment Method: Credit Card (Mock)',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 25),

            // Order Summary
            Expanded(
              child: ListView(
                children: [
                  ...cartItems.map(
                    (item) => ListTile(
                      title: Text(
                        '${item.product.name} x${item.quantity}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      trailing: Text(
                        '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 105, 95, 5),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Total',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    trailing: Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 105, 95, 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text("Place Order"),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: Text(
                          "Please log in to place an order.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                    return;
                  }

                  if (addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: Text(
                          "Please enter your address",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
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
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: Text(
                          "Order placed successfully!",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: Text(
                          "Error placing order: $e",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
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
