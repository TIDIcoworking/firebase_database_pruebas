/*import 'package:ejemploaa/login/domain/auth_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  final authUseCase = ref.watch(authUseCaseProvider);
  return AuthNotifier(authUseCase);
});

//CnageNotifier se usa para almacenar algun estado y notificar cuando se cambie
class AuthNotifier extends ChangeNotifier {
  final AuthUseCase _authUseCase;

  AuthNotifier(this._authUseCase);

  Future<UserCredential> registerUser(String phoneNumber) async {
    // Implementar lógica para registrar usuarios
    return registerUser(phoneNumber);
  }

  Future<UserCredential> signInUser(String phoneNumber) async {
    // Implementar lógica para iniciar sesión
    return signInUser(phoneNumber);
  }

  Future<void> signOutUser() async {
    // Implementar lógica para cerrar sesión
  }
}*/