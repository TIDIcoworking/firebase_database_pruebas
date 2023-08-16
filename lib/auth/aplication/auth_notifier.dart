import 'package:ejemploaa/auth/domain/verify_phone_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<void> {
  final VerifyPhoneNumberUseCase _verifyPhoneNumberUseCase;

  AuthNotifier(this._verifyPhoneNumberUseCase) : super(null);

  Future<void> verifyPhoneNumber(String phoneNumber) {
    return _verifyPhoneNumberUseCase.call(phoneNumber);
  }
}