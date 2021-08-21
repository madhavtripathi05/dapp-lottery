// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.address,
    required this.privateKey,
    required this.avatar,
    required this.name,
  });

  String address;
  String privateKey;
  String avatar;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        address: json["address"],
        privateKey: json["privateKey"],
        avatar: json["avatar"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "privateKey": privateKey,
        "avatar": avatar,
        "name": name,
      };
}
