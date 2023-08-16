import 'package:ejemploaa/auth/aplication/auth_notifier.dart';
import 'package:ejemploaa/auth/data/auth_repository.dart';
import 'package:ejemploaa/auth/domain/verify_phone_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);

final verifyPhoneNumberUseCaseProvider = Provider<VerifyPhoneNumberUseCase>(
  (ref) => VerifyPhoneNumberUseCase(ref.watch(authRepositoryProvider)),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, void>(
  (ref) => AuthNotifier(ref.watch(verifyPhoneNumberUseCaseProvider)),
);