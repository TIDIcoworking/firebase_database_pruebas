import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider usado para accedar a dependencias y objetos que no cambian
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) { 
  return FirebaseAuth.instance;
});

final phoneVerificationProvider =
    FutureProvider.autoDispose<UserCredential>((ref) async {
  final auth = ref.read(firebaseAuthProvider);
  final confirmationResult = await auth.signInWithPhoneNumber('+123456789');

  // En este punto, Firebase enviará un mensaje de verificación al número de teléfono proporcionado.
  // El usuario deberá ingresar el código de verificación enviado al dispositivo.

  final verificationCode = '123456'; // Reemplaza con el código de verificación ingresado por el usuario

  final userCredential = await confirmationResult.confirm(verificationCode);

  return userCredential;
});