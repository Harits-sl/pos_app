import 'dart:convert';

import 'package:pos_app/src/data/dataSources/remote/web/config.dart';
import 'package:pos_app/src/data/models/transaction_model.dart';
import 'package:http/http.dart' as http;

class ReportService {
  Future<List<TransactionModel>> getToday() async {
    final response = await http.get(Uri.parse('$BASE_URL/api/report/today'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      List<TransactionModel> transactions =
          body['data'].map<TransactionModel>((menu) {
        return TransactionModel.fromJson(menu);
      }).toList();

      return transactions;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report');
    }
  }

  Future<List<TransactionModel>> getYesterday() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/api/report/yesterday'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      List<TransactionModel> transactions =
          body['data'].map<TransactionModel>((menu) {
        return TransactionModel.fromJson(menu);
      }).toList();

      return transactions;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report');
    }
  }

  Future<List<TransactionModel>> getThisWeek() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/api/report/this-week'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      List<TransactionModel> transactions =
          body['data'].map<TransactionModel>((menu) {
        return TransactionModel.fromJson(menu);
      }).toList();

      return transactions;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report');
    }
  }

  Future<List<TransactionModel>> getThisMonth() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/api/report/this-month'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      List<TransactionModel> transactions =
          body['data'].map<TransactionModel>((menu) {
        return TransactionModel.fromJson(menu);
      }).toList();

      return transactions;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report');
    }
  }

  Future<List<TransactionModel>> getCustom(
      DateTime startDate, DateTime endDate) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = jsonEncode({
      'start_date': '$startDate',
      'end_date': '$endDate',
    });
    final response = await http.post(
      Uri.parse('$BASE_URL/api/report/custom'),
      headers: header,
      body: body,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      List<TransactionModel> transactions =
          body['data'].map<TransactionModel>((menu) {
        return TransactionModel.fromJson(menu);
      }).toList();

      return transactions;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report');
    }
  }
}
