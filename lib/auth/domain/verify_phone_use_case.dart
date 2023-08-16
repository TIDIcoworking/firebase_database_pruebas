import 'package:ejemploaa/auth/data/auth_repository.dart';

class VerifyPhoneNumberUseCase {
  final AuthRepository _authRepository;

  VerifyPhoneNumberUseCase(this._authRepository);

  Future<void> call(String phoneNumber) {
    return _authRepository.verifyPhoneNumber(phoneNumber);
  }
}