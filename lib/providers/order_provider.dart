import 'package:e_commerce_flutter_app/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository());
