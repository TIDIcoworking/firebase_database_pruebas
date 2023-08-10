// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/riverpod/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider.autoDispose<UserService>(
    (ref) => UserService(ref.read(userRepositoryProvider)));

class UserService {
  final UserRepository _userRepository;
  final int documentsPerPage = 10;

  UserService(this._userRepository);
  
  /*Stream<QuerySnapshot> getUsers() {
    return _userRepository.getUsers();
  }*/
  Stream<QuerySnapshot> getUsers(int documentsPerPage, DocumentSnapshot? lastDocument) {
  Query query = _userRepository.usersCollection
      .orderBy('name')
      .limit(documentsPerPage);

  if (lastDocument != null) {
    query = query.startAfter([lastDocument['name']]);
  }

  return query.snapshots();
}

  Future<void> addUser(Map<String, dynamic> userData) {
    return _userRepository.addUser(userData);
  }
  
  Future<void> deleteUser(String userId) {
    return _userRepository.deleteUser(userId);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) {
    return _userRepository.updateUser(userId, userData);
  }
}


