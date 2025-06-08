import 'package:equatable/equatable.dart';

import 'package:pos_app/src/data/models/detail_transaction_model.dart';

class TransactionModel extends Equatable {
  final String? id;
  final int total;
  final List<DetailTransactionModel>? detailTransactions;
  final String? typePayment;
  final int pay;
  final int change;
  final String? buyer;
  final DateTime? createdAt;
  // final int hpp;

  const TransactionModel({
    this.id,
    this.total = 0,
    this.detailTransactions,
    this.typePayment,
    this.pay = 0,
    this.change = 0,
    this.buyer,
    this.createdAt,
    // this.hpp = 0,
  });

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    // result.addAll({'id': id});
    result.addAll({'total': total});
    result.addAll({
      'detail_transactions': detailTransactions!.map((d) => d.toMap()).toList()
    });
    // result.addAll({'dateTimeOrder': dateTimeOrder});
    result.addAll({'type_payment': typePayment});
    result.addAll({'pay': pay});
    result.addAll({'change': change});
    result.addAll({'buyer': buyer});
    // result.addAll({'hpp': hpp});

    return result;
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['transaction_id'] ?? '',
      total: int.tryParse(json['total']) ?? 0,
      detailTransactions: json['detail_transactions'] != null
          ? List<DetailTransactionModel>.from(json['detail_transactions']
              ?.map((x) => DetailTransactionModel.fromJson(x)))
          : null,

      typePayment: json['type_payment'] ?? '',
      pay: json['pay'] ?? 0,
      change: json['change'] ?? 0,
      buyer: json['buyer'] ?? '',
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      // hpp: json['hpp'],
    );
  }

  TransactionModel copyWith({
    String? id,
    int? total,
    List<DetailTransactionModel>? detailTransactions,
    DateTime? dateTimeOrder,
    String? typePayment,
    int? pay,
    int? change,
    String? buyer,
    // int? hpp,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      total: total ?? this.total,
      detailTransactions: detailTransactions ?? this.detailTransactions,
      typePayment: typePayment ?? this.typePayment,
      pay: pay ?? this.pay,
      change: change ?? this.change,
      buyer: buyer ?? this.buyer,
      // hpp: hpp ?? this.hpp,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      total,
      detailTransactions,
      typePayment,
      pay,
      change,
      buyer,
      // hpp,
    ];
  }
}
