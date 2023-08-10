// ignore_for_file: prefer_const_declarations

import 'package:ejemploaa/login/domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/firebase_auth_repository.dart';
import 'package:ejemploaa/login/data/firestore_repository.dart';

final nameController =TextEditingController();
final emailController =TextEditingController();
final passwordController =TextEditingController();
//final idController= TextEditingController();



final phoneVerificationProvider =
    FutureProvider.autoDispose<AuthResult>((ref) async {
  final authRepository = ref.read(firebaseAuthProvider);
  final authResult = await _signInWithPhoneNumber(authRepository as FirebaseAuthRepository);
  return _convertUserCredentialToAuthResult(authResult);
});

Future<UserCredential> _signInWithPhoneNumber(
  FirebaseAuthRepository authRepository) async {
    final phoneNumber = '+123456789'; // Reemplaza con el número de teléfono ingresado por el usuario
    final confirmationResult = await authRepository.signInWithPhoneNumber(phoneNumber);
    final verificationCode = '123456'; // Reemplaza con el código de verificación ingresado por el usuario
    //final userCredential = await confirmationResult.confirm(verificationCode);
    return confirmationResult;
}

AuthResult _convertUserCredentialToAuthResult(UserCredential userCredential) {
  /*final user = User(
    uid: userCredential.user!.uid,
    name: '', // Reemplaza con el nombre del usuario
    email: '', // Reemplaza con el correo del usuario
    password: '', // Reemplaza con la contraseña del usuario
  ); */
  final user=null;
  final authResult = AuthResult(
    user: user,
    verificationId: userCredential.toString(),//.verificationId ?? '',
  );

  return authResult;
}

//FutureProvider sirve para obtener el resultado de una llamada a la API, se usa con el autoDispose
//autoDispose asegura que la conexion de transmision se cierre tan pronto como se abandone la pag donde se ve el proveedor

/*final saveUserDataProvider = FutureProvider.autoDispose<void>((ref) async {
  final firestoreRepository = ref.read(firestoreProvider);
  final authResult = ref.read(phoneVerificationProvider);
  final user = authResult.asData!.value.user;
  final name = nameController.text;// Obtén el nombre del usuario
  final email = emailController.text;// Obtén el correo del usuario
  final password = passwordController.text;// Obtén la contraseña del usuario
  return firestoreRepository.saveUserData(user.uid, name, email, password);
});

final getUserDataProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final firestoreRepository = ref.read(firestoreProvider);
  final authResult = ref.read(phoneVerificationProvider);
  final user = authResult.data!.value.user;
  return firestoreRepository.getUserData(user.uid);
});*/