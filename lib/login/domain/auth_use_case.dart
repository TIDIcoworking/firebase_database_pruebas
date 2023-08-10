import 'package:ejemploaa/login/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<UserCredential> registerUser(String phoneNumber) async {
    return _authRepository.registerUser(phoneNumber);
  }

  Future<UserCredential> signInUser(String phoneNumber) async {
    return _authRepository.signInUser(phoneNumber);
  }

  Future<void> signOutUser() async {
    return _authRepository.signOutUser();
  }
}