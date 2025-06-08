import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pos_app/src/data/dataSources/remote/web/config.dart';
import 'package:pos_app/src/data/models/transaction_model.dart';

class TransactionService {
  Future<List<TransactionModel>> getAllTransactions() async {
    final response = await http.get(Uri.parse('$BASE_URL/api/transaction/'));
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
      throw Exception('Failed to load transaction');
    }
  }

  Future<TransactionModel> getTransactionByID(String id) async {
    final response = await http.get(Uri.parse('$BASE_URL/api/transaction/$id'));
    log('response: ${response}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map body = jsonDecode(response.body) as Map<String, dynamic>;

      TransactionModel transaction = TransactionModel.fromJson(body['data'][0]);
      log('transactiodasdn: ${transaction}');
      return transaction;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load transaction');
    }
  }

  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    Map<String, String> header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String body = jsonEncode(transaction.toJson());
    var response = await http.post(
      Uri.parse('$BASE_URL/api/transaction/'),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var transaction = TransactionModel(id: data['data']);
      return transaction;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed add transaction');
    }
  }
}
