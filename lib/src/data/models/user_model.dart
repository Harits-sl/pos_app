import 'dart:convert';

import 'package:pos_app/src/core/utils/role.dart';

class UserModel {
  final String id;
  final String name;
  final String username;
  final String? password;
  final Role role;
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'username': username});
    result.addAll({'password': password});
    result.addAll({'role': Role.getValue(role)});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    Role role = Role.getTypeByTitle(map['role']);

    return UserModel(
      id: map['user_id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      role: role,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
