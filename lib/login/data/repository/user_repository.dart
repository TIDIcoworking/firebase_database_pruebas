import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser({
    required String name,
    required String lastname,
    required String email,
    required String password,
  }) async {
    await _usersCollection.doc().set({
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
    });
  }
}
