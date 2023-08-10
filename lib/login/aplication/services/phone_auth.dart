// ignore_for_file: prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthServiceProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final phoneAuthProvider =
    Provider<PhoneAuth>((ref) => PhoneAuth(ref));

class PhoneAuth {
  final Ref ref;
  

  PhoneAuth(this.ref);

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onError,
    required Function(String verificationId, String smsCode) onVerificationCompleted,
    required Function(FirebaseAuthException exception) onVerificationFailed,
  }) async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthServiceProvider);
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
      onVerificationCompleted(phoneAuthCredential.verificationId!, phoneAuthCredential.smsCode!);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException firebaseAuthException) {
      onVerificationFailed(firebaseAuthException);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) {
      onCodeSent(verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // El tiempo de espera para la verificación automática ha expirado.
    };

    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> signInWithSmsCode(String verificationId, String smsCode) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthServiceProvider);
    await firebaseAuth.signInWithCredential(credential);
  }
}