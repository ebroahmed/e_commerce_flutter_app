import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/providers/product_provider.dart';
import 'package:e_commerce_flutter_app/screens/admin_add_product_screen.dart';
import 'package:e_commerce_flutter_app/screens/cart_screen.dart';
import 'package:e_commerce_flutter_app/screens/profile_screen.dart';
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
    // Refresh product list every time home screen is opened
    Future.microtask(() {
      ref.refresh(filteredProductListProvider);
    });

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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Ecommerce',
          style: GoogleFonts.spectralSc(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 70,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            // Profile
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),

            // Admin Panel
            ListTile(
              leading: Icon(
                Icons.admin_panel_settings,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
              title: Text(
                'Admin Panel',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () async {
                Navigator.pop(context); // Close drawer first
                final role = await ref.read(userRoleProvider.future);
                if (role == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminAddProductScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text("Access denied: Admins only"),
                    ),
                  );
                }
              },
            ),

            // Logout
            Consumer(
              builder: (context, ref, _) => ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  final auth = ref.read(authRepositoryProvider);
                  auth.logout();
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.shopping_cart_rounded,
          color: Theme.of(context).colorScheme.surface,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          );
        },
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
                  return Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
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
