import 'package:e_commerce_flutter_app/models/product_model.dart';
import 'package:e_commerce_flutter_app/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),

            //  Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(color: const Color.fromARGB(255, 105, 95, 5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
