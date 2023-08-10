class User {
  final String uid;
  final String name;
  final String email;
  final String password;

  User({
    this.uid="",
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthResult {
  final User user;
  final String verificationId;

  AuthResult({
    required this.user,
    required this.verificationId,
  });
}