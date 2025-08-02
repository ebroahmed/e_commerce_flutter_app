import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/providers/product_provider.dart';
import 'package:e_commerce_flutter_app/widgets/category_filter.dart';
import 'package:e_commerce_flutter_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    // Optional: listen to changes and update search term provider
    searchController.addListener(() {
      ref.read(searchTermProvider.notifier).state = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authRepositoryProvider);
    final productsAsync = ref.watch(filteredProductListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Ecommerce',
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Theme.of(context).colorScheme.surface,
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.8),
                ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(searchTermProvider.notifier).state = value;
              },
            ),
          ),

          //  Category filter
          const CategoryFilter(),

          //  Product grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, index) =>
                      ProductCard(product: products[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
