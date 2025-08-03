import 'package:e_commerce_flutter_app/providers/cart_provider.dart';
import 'package:e_commerce_flutter_app/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartNotifier.totalPrice;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'My Cart',
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (_, index) {
                      final item = cartItems[index];
                      return Card(
                        color: Theme.of(context).colorScheme.onPrimary,
                        elevation: 5,
                        child: ListTile(
                          leading: Image.network(
                            item.product.imageUrl,
                            width: 60,
                          ),
                          title: Text(
                            item.product.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${item.product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 105, 95, 5),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: item.quantity > 1
                                        ? () {
                                            final updated = item.copyWith(
                                              quantity: item.quantity - 1,
                                            );
                                            cartNotifier.state[index] = updated;
                                            cartNotifier.state = [
                                              ...cartNotifier.state,
                                            ];
                                          }
                                        : null,
                                  ),
                                  Text(item.quantity.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      final updated = item.copyWith(
                                        quantity: item.quantity + 1,
                                      );
                                      cartNotifier.state[index] = updated;
                                      cartNotifier.state = [
                                        ...cartNotifier.state,
                                      ];
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                cartNotifier.removeFromCart(item.product.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 105, 95, 5),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text('Proceed to Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
