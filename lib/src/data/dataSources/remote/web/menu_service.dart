import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pos_app/src/data/dataSources/remote/web/config.dart';
import 'package:pos_app/src/data/models/menu_model.dart';

class MenuService {
  Future<List<MenuModel>> getAllMenus() async {
    final response = await http.get(Uri.parse('$BASE_URL/api/menu/'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      List<MenuModel> menus = body['data'].map<MenuModel>((menu) {
        return MenuModel.fromJson(menu);
      }).toList();

      return menus;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Menu');
    }
  }

  Future<MenuModel> getMenuByID(String id) async {
    final response = await http.get(Uri.parse('$BASE_URL/api/menu/$id'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;
      return MenuModel.fromJson(body['data']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Menu');
    }
  }

  Future<bool> addMenu(MenuModel menu) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = jsonEncode(menu.toJson());
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$BASE_URL/api/menu/'),
    );
    request.fields['name'] = menu.name;
    request.fields['hpp'] = menu.hpp.toString();
    request.fields['price'] = menu.price.toString();
    request.fields['quantity'] = menu.quantity.toString();
    request.fields['minimum_quantity'] = menu.minimumQuantity.toString();
    request.fields['type'] = menu.typeMenu;
    if (menu.image != null && menu.image != '') {
      request.files.add(http.MultipartFile(
        'image',
        File(menu.image!).readAsBytes().asStream(),
        File(menu.image!).lengthSync(),
        filename: menu.image!.split("/").last,
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    log('response: ${response.statusCode}');
    log('response: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 500) {
      throw Exception(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed add menu');
    }
  }

  Future<bool> updateMenu(MenuModel menu) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = jsonEncode(menu.toJson());
    log('menu: ${menu}');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$BASE_URL/api/menu/${menu.id}'),
    );
    request.fields['_method'] = 'PUT';
    request.fields['name'] = menu.name;
    request.fields['hpp'] = menu.hpp.toString();
    request.fields['price'] = menu.price.toString();
    request.fields['quantity'] = menu.quantity.toString();
    request.fields['minimum_quantity'] = menu.minimumQuantity.toString();
    request.fields['type'] = menu.typeMenu;
    log('menu.image!: ${menu.image!}');
    if (menu.image != null && menu.image != '') {
      request.files.add(http.MultipartFile(
        'image',
        File(menu.image!).readAsBytes().asStream(),
        File(menu.image!).lengthSync(),
        filename: menu.image!.split("/").last,
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    log('response: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed Edit menu');
    }
  }

  void deleteMenu(String id) async {
    await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/menu/$id'),
    );
  }
}
