import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_flutter_app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

final authRepositoryProvider = Provider((ref) => AuthRepository());
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authState;
});

final userRoleProvider = FutureProvider<String?>((ref) async {
  final authState = await ref.watch(authStateProvider.future);
  if (authState == null) return null;

  final doc = await FirebaseFirestore.instance
      .collection('admins')
      .doc(authState.uid)
      .get();

  if (doc.exists) return doc['role'];
  return 'user';
});
