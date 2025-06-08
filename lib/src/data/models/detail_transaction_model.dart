import 'dart:convert';

import 'package:pos_app/src/core/utils/status_inventory.dart';

class DetailTransactionModel {
  final String menuId;
  final int totalBuy;
  final int amount;
  final String? name;
  final String? typeMenu;
  final int? price;
  final int? hpp;
  final StatusInventory? status;

  DetailTransactionModel({
    required this.menuId,
    required this.totalBuy,
    required this.amount,
    this.name,
    this.typeMenu,
    this.price,
    this.hpp,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'menu_id': menuId});
    result.addAll({'total_buy': totalBuy});
    result.addAll({'amount': amount});

    return result;
  }

  factory DetailTransactionModel.fromJson(Map<String, dynamic> json) {
    return DetailTransactionModel(
      menuId: json['menu_id'] ?? '',
      totalBuy: int.tryParse(json['total_buy']) ?? 0,
      amount: int.tryParse(json['amount']) ?? 0,
      name: json['name'],
      typeMenu: json['type'],
      price: int.tryParse(json['price']),
      hpp: int.tryParse(json['hpp']),
      status: json['status'] != null
          ? StatusInventory.getTypeByTitle(json['status'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());
}
