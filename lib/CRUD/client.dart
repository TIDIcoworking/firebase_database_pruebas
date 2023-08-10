import 'dart:convert';

Client clientsFromJson(String str) => Client.fromJson(json.decode(str));

String clientsToJson(Client data) => json.encode(data.toJson());

class Client {
    String id;
    final String username;
    final String lastname;
    final String email;
    final String password; 
    final String birthday;

    Client({
        this.id="",
        required this.username,
        required this.lastname,
        required this.email,
        required this.password,
        required this.birthday,
    });

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        username: json["username"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        birthday: json["birthday"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "lastname": lastname,
        "email": email,
        "birthday":birthday,
    };
}
