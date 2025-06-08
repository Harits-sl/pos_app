part of 'edit_product_bloc.dart';

abstract class EditProductEvent extends Equatable {
  const EditProductEvent();

  @override
  List<Object> get props => [];
}

class EditImage extends EditProductEvent {
  const EditImage({required this.editImage});

  final String editImage;

  @override
  List<Object> get props => [editImage];
}

class EditNameChanged extends EditProductEvent {
  const EditNameChanged({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class EditTypeProductChanged extends EditProductEvent {
  const EditTypeProductChanged({required this.typeProduct});

  final String typeProduct;

  @override
  List<Object> get props => [typeProduct];
}

class EditPriceChanged extends EditProductEvent {
  const EditPriceChanged({required this.price});

  final int price;

  @override
  List<Object> get props => [price];
}

class EditHppChanged extends EditProductEvent {
  const EditHppChanged({required this.hpp});

  final int hpp;

  @override
  List<Object> get props => [hpp];
}

class EditQuantityChanged extends EditProductEvent {
  const EditQuantityChanged({required this.quantity});

  final int quantity;

  @override
  List<Object> get props => [quantity];
}

class EditMinimumQuantityChanged extends EditProductEvent {
  const EditMinimumQuantityChanged({required this.minimumQuantity});

  final int minimumQuantity;

  @override
  List<Object> get props => [minimumQuantity];
}

class FetchProductById extends EditProductEvent {
  const FetchProductById({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class EditClearState extends EditProductEvent {}

class ButtonEditProductPressed extends EditProductEvent {}
