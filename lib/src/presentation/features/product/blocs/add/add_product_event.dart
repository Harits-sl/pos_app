part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class AddImage extends AddProductEvent {
  const AddImage({required this.image});

  final String image;

  @override
  List<Object> get props => [image];
}

class NameChanged extends AddProductEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class TypeProductChanged extends AddProductEvent {
  const TypeProductChanged({required this.typeProduct});

  final String typeProduct;

  @override
  List<Object> get props => [typeProduct];
}

class PriceChanged extends AddProductEvent {
  const PriceChanged({required this.price});

  final int price;

  @override
  List<Object> get props => [price];
}

class HppChanged extends AddProductEvent {
  const HppChanged({required this.hpp});

  final int hpp;

  @override
  List<Object> get props => [hpp];
}

class QuantityChanged extends AddProductEvent {
  const QuantityChanged({required this.quantity});

  final int quantity;

  @override
  List<Object> get props => [quantity];
}

class MinimumQuantityChanged extends AddProductEvent {
  const MinimumQuantityChanged({required this.minimumQuantity});

  final int minimumQuantity;

  @override
  List<Object> get props => [minimumQuantity];
}

class ButtonAddProductPressed extends AddProductEvent {}

class ClearState extends AddProductEvent {}
