// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async{
        String smsCode = 'xxxx';
        
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle codeAutoRetrievalTimeout
      },
    );
  }

  Future<void> verifyPhoneNumber(String verificationId, String smsCode) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }
  
  
  Future<UserCredential> registerUser(String phoneNumber) async {
    // Implementar lógica para registrar usuarios con número de teléfono
    return registerUser(phoneNumber);
  }

  Future<UserCredential> signInUser(String phoneNumber) async {
    // Implementar lógica para iniciar sesión con número de teléfono
    return signInUser(phoneNumber);
  }

  Future<void> signOutUser() async {
    // Implementar lógica para cerrar sesión
  }
}

/*class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> registerUser(String phoneNumber) async {
    // Implementar lógica para registrar usuarios con número de teléfono
    return registerUser(phoneNumber);
  }

  Future<UserCredential> signInUser(String phoneNumber) async {
    // Implementar lógica para iniciar sesión con número de teléfono
    return signInUser(phoneNumber);
  }

  Future<void> signOutUser() async {
    // Implementar lógica para cerrar sesión
  }
}*/