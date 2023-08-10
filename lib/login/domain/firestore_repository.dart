// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference peopleCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getUserData(String userId) async {
    // Implementar lógica para obtener datos de usuario en Firestore
    return getUserData(userId);
  }

  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    // Implementar lógica para guardar datos de usuario en Firestore
  }

  Future<void> deletePerson(String personId) {
    return peopleCollection
        .doc(personId)
        .delete()
        .then((value) => print("Persona eliminada"))
        .catchError((error) => print("Error al eliminar la persona: $error"));
  }

}