import 'package:e_commerce_flutter_app/models/cart_item_model.dart';
import 'package:e_commerce_flutter_app/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product, int quantity) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final updated = state[index].copyWith(
        quantity: state[index].quantity + quantity,
      );
      state = [...state]..[index] = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice =>
      state.fold(0, (sum, item) => sum + item.product.price * item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
