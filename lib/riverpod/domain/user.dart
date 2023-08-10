class User {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String birthday;
  final String gender;

  User({
    this.id="",
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.birthday,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastName,
      'email': email,
      'password': password,
      'birthday': birthday,
      'gender': gender,
    };
  }
}