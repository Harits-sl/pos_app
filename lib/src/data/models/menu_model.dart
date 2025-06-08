import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:pos_app/src/core/utils/status_inventory.dart';

class MenuModel extends Equatable {
  final String? id;
  final String name;
  final String typeMenu;
  final int price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int hpp;
  final int? quantity;
  final int? minimumQuantity;
  final String? unit;
  final StatusInventory? status;
  final String? image;

  const MenuModel({
    this.id,
    required this.name,
    required this.typeMenu,
    required this.price,
    this.createdAt,
    this.updatedAt,
    required this.hpp,
    this.quantity,
    this.minimumQuantity,
    this.unit,
    this.status,
    this.image,
  });

  Map<String, dynamic> toFirestore() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'typeMenu': typeMenu});
    result.addAll({'price': price});
    result.addAll({'createdAt': createdAt});
    result.addAll({'updatedAt': updatedAt});
    result.addAll({'hpp': hpp});
    result.addAll({'quantity': quantity});
    result.addAll({'minimumQuantity': minimumQuantity});
    result.addAll({'unit': unit});
    result.addAll(
        {'status': status != null ? StatusInventory.getValue(status!) : null});

    return result;
  }

  factory MenuModel.fromFirestore(Map<String, dynamic> firestore) {
    StatusInventory? status = firestore['status'] != null
        ? StatusInventory.getTypeByTitle(firestore['status'])
        : null;

    return MenuModel(
      id: firestore['id'] ?? '',
      name: firestore['name'] ?? '',
      typeMenu: firestore['typeMenu'] ?? '',
      price: firestore['price']?.toInt() ?? 0,
      createdAt: (firestore['createdAt'] as Timestamp).toDate(),
      updatedAt: (firestore['updatedAt'] as Timestamp).toDate(),
      hpp: firestore['hpp']?.toInt() ?? 0,
      quantity: firestore['quantity']?.toInt() ?? 0,
      minimumQuantity: firestore['minimumQuantity']?.toInt() ?? 0,
      unit: firestore['unit'] ?? '',
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'type': typeMenu});
    result.addAll({'price': price});
    result.addAll({'hpp': hpp});
    result.addAll({'quantity': quantity});
    result.addAll({'minimum_quantity': minimumQuantity});
    result.addAll(
        {'status': status != null ? StatusInventory.getValue(status!) : null});

    return result;
  }

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    StatusInventory? status = json['status'] != null
        ? StatusInventory.getTypeByTitle(json['status'])
        : null;

    return MenuModel(
      id: json['menu_id'] ?? '',
      name: json['name'] ?? '',
      typeMenu: json['type'] ?? '',
      price: int.tryParse(json['price']) ?? 0,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['created_at']).toLocal(),
      hpp: int.tryParse(json['hpp']) ?? 0,
      quantity: int.tryParse(json['quantity']) ?? 0,
      minimumQuantity: int.tryParse(json['minimum_quantity']) ?? 0,
      status: status,
      image: json['image'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        typeMenu,
        price,
        name,
        createdAt,
        updatedAt,
        hpp,
        quantity,
        minimumQuantity,
        unit,
        status,
        image,
      ];

  MenuModel copyWith({
    String? id,
    String? name,
    String? typeMenu,
    int? price,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? hpp,
    int? quantity,
    int? minimumQuantity,
    String? unit,
    StatusInventory? status,
    String? image,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      typeMenu: typeMenu ?? this.typeMenu,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hpp: hpp ?? this.hpp,
      quantity: quantity ?? this.quantity,
      minimumQuantity: minimumQuantity ?? this.minimumQuantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }
}
