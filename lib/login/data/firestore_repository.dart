// ignore_for_file: prefer_collection_literals

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

class FirestoreRepository {
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  Future<void> saveUserData(String uid, String name, String email, String password) {
    return _firestore
        .collection('users')
        .doc(uid)
        .set({'name': name, 'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    final userData = await _firestore.collection('users').doc(uid).get();
    return userData.data() ?? Map<String, dynamic>();
  }
}