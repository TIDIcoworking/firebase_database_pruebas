// ignore_for_file: constant_identifier_names

import 'dart:convert';

Users clientsFromJson(String str) => Users.fromJson(json.decode(str));

String clientsToJson(Users data) => json.encode(data.toJson());

class Users {
    String id;
    final String name;
    final String lastname;
    final String email;
    final String password;
    String gender;
    final String birthday;

    Users({
        this.id="",
        required this.name,
        required this.lastname,
        required this.email,
        required this.password,
        required this.gender,
        required this.birthday,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
        birthday: json["birthday"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "gender": gender,
        "birthday":birthday,
    };
}
