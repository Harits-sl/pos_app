import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pos_app/src/data/dataSources/remote/web/config.dart';
import 'package:pos_app/src/data/models/menu_model.dart';
import 'package:pos_app/src/data/models/user_model.dart';

class UserService {
  Future<UserModel> login(String username, String password) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = jsonEncode({
      'username': username,
      'password': password,
    });

    final response = await http.post(
      Uri.parse('$BASE_URL/api/user/login'),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromMap(body['data']);
    } else {
      Map body = jsonDecode(response.body) as Map<String, dynamic>;
      log('body: ${body}');

      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(body['message']);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(Uri.parse('$BASE_URL/api/user'));

    log('responsedadasdsa.statusCode: ${response.body}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;
      log('response.body: ${response.body}');

      List<UserModel> users = body['data'].map<UserModel>((user) {
        return UserModel.fromMap(user);
      }).toList();
      return users;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<UserModel> getUserByID(String id) async {
    final response = await http.get(Uri.parse('$BASE_URL/api/user/$id'));
    log('id: ${id}');

    if (response.statusCode == 200) {
      log('response.statusCode: ${response.body}');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;
      log('response.body: ${response.body}');

      return UserModel.fromMap(body['data']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<bool> addUser(UserModel user) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = user.toJson();
    var response = await http.post(
      Uri.parse('$BASE_URL/api/user/'),
      headers: header,
      body: body,
    );
    log('body: ${body}');
    log('response: ${response.statusCode}');
    log('response: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed add menu');
    }
  }

  Future<bool> editUser(UserModel user) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = user.toJson();
    var response = await http.put(
      Uri.parse('$BASE_URL/api/user/${user.id}'),
      headers: header,
      body: body,
    );
    log('body: ${body}');
    log('response: ${response.statusCode}');
    log('response: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed add menu');
    }
  }

  void deleteUser(String id) async {
    await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/user/$id'),
    );
  }
}
