import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>((ref) => UserRepository());

class UserRepository {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  DocumentSnapshot? lastDocument;
  final int documentsPerPage=10;
  
  /*Stream<QuerySnapshot> getUsers() {
    return usersCollection.snapshots();
  }*/
  Stream<QuerySnapshot> getUsers() {
  if (lastDocument == null) {
    // Fetching the first page
    return usersCollection
        .orderBy('name')
        .limit(documentsPerPage)
        .snapshots();
  } else {
    // Fetching the next page
    return usersCollection
        .orderBy('name')
        .startAfter([lastDocument!['name']])
        .limit(documentsPerPage)
        .snapshots();
  }
}

  Future<void> addUser(Map<String, dynamic> userData) {
    return usersCollection.add(userData);
  }

  Future<void> deleteUser(String userId) {
    return usersCollection.doc(userId).delete();
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) {
    return usersCollection.doc(userId).update(userData);
  }
}