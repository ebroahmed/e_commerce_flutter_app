// lib/screens/product_details_screen.dart
import 'package:e_commerce_flutter_app/models/product_model.dart';
import 'package:e_commerce_flutter_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          product.name,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(product.imageUrl, fit: BoxFit.contain),
            ),

            //  Product Info
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 119, 108, 6),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: const Color.fromARGB(255, 133, 30, 22),
                          size: 20,
                        ),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text(quantity.toString(), style: TextStyle(fontSize: 20)),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 20,
                          color: const Color.fromARGB(255, 15, 119, 18),
                        ),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .addToCart(product, quantity);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            content: Text(
                              'Added ${product.name} to cart',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
