import 'package:e_commerce_flutter_app/providers/auth_provider.dart';
import 'package:e_commerce_flutter_app/providers/order_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final ordersAsync = ref.watch(pastOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: authAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("User not logged in"));
          }

          return Column(
            children: [
              const SizedBox(height: 30),

              // Profile Image + Email
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueGrey,
                child: Text(
                  user.email?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(user.email ?? "", style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 30),
              const Divider(),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "My Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Order List
              Expanded(
                child: ordersAsync.when(
                  data: (orders) {
                    if (orders.isEmpty) {
                      return const Center(child: Text("No orders yet."));
                    }
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (_, index) {
                        final order = orders[index];
                        return ListTile(
                          title: Text("Order to: ${order.address}"),
                          subtitle: Text(order.timestamp.toDate().toString()),
                          trailing: Text('\$${order.total.toStringAsFixed(2)}'),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged out")),
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
