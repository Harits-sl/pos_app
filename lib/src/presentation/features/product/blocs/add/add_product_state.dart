part of 'add_product_bloc.dart';

enum Status {
  initial,
  success,
  failed,
}

class AddProductState extends Equatable {
  const AddProductState({
    this.image = '',
    this.name = '',
    this.typeProduct = '',
    this.price = 0,
    this.status = Status.initial,
    this.message = '',
    this.hpp = 0,
    this.quantity = 0,
    this.minimumQuantity = 0,
  });

  final String image;
  final String name;
  final String typeProduct;
  final int price;
  final Status status;
  final String message;
  final int hpp;
  final int quantity;
  final int minimumQuantity;

  AddProductState copyWith({
    String? image,
    String? name,
    String? typeProduct,
    int? price,
    Status? status,
    String? message,
    int? hpp,
    int? quantity,
    int? minimumQuantity,
  }) {
    return AddProductState(
      image: image ?? this.image,
      name: name ?? this.name,
      typeProduct: typeProduct ?? this.typeProduct,
      price: price ?? this.price,
      status: status ?? this.status,
      message: message ?? this.message,
      hpp: hpp ?? this.hpp,
      quantity: quantity ?? this.quantity,
      minimumQuantity: minimumQuantity ?? this.minimumQuantity,
    );
  }

  @override
  List<Object> get props {
    return [
      image,
      name,
      typeProduct,
      price,
      status,
      message,
      hpp,
      quantity,
      minimumQuantity,
    ];
  }
}

// class AddProductInitial extends AddProductState {}

// class AddProductLoading extends AddProductState {}

// class AddProductSuccess extends AddProductState {
//   final MenuModel menus;

//   const AddProductSuccess(this.menus);

//   @override
//   List<Object> get props => [menus];
// }

// class AddProductFailed extends AddProductState {
//   final String error;

//   const AddProductFailed(this.error);

//   @override
//   List<Object> get props => [error];
// }
