/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/login/data/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreNotifierProvider = ChangeNotifierProvider<FirestoreNotifier>((ref) {
  final firestoreUseCase = ref.watch(firestoreUseCaseProvider);
  return FirestoreNotifier(firestoreUseCase);
});

class FirestoreNotifier extends ChangeNotifier {
  final FirestoreRepository _firestoreRepository;

  FirestoreNotifier(this._firestoreRepository);

  Future<DocumentSnapshot> getUserData(String userId) async {
    // Implementar lógica para obtener datos de usuario en Firestore
    return getUserData(userId);
  }

  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    // Implementar lógica para guardar datos de usuario en Firestore
  }
}*/