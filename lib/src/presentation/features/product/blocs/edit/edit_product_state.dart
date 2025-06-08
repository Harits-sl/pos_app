part of 'edit_product_bloc.dart';

enum EditStatus {
  initial,
  successFetch,
  successEdit,
  failed,
  loading,
  edit,
}

class EditProductState extends Equatable {
  const EditProductState({
    this.id,
    this.image,
    this.editImage,
    this.name,
    this.typeMenu,
    this.price,
    this.status,
    this.message,
    this.hpp,
    this.quantity,
    this.minimumQuantity,
  });

  final String? id;
  final String? image;
  final String? editImage;
  final String? name;
  final String? typeMenu;
  final int? price;
  final EditStatus? status;
  final String? message;
  final int? hpp;
  final int? quantity;
  final int? minimumQuantity;

  EditProductState copyWith({
    String? id,
    String? image,
    String? editImage,
    String? name,
    String? typeMenu,
    int? price,
    EditStatus? status,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? hpp,
    int? quantity,
    int? minimumQuantity,
  }) {
    return EditProductState(
      id: id ?? this.id,
      image: image ?? this.image,
      editImage: editImage ?? this.editImage,
      name: name ?? this.name,
      typeMenu: typeMenu ?? this.typeMenu,
      price: price ?? this.price,
      status: status ?? this.status,
      message: message ?? this.message,
      hpp: hpp ?? this.hpp,
      quantity: quantity ?? this.quantity,
      minimumQuantity: minimumQuantity ?? this.minimumQuantity,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      image,
      editImage,
      name,
      typeMenu,
      price,
      status,
      message,
      hpp,
      quantity,
      minimumQuantity,
    ];
  }
}

// class AddMenuInitial extends AddMenuState {}

// class AddMenuLoading extends AddMenuState {}

// class AddMenuSuccess extends AddMenuState {
//   final MenuModel menus;

//   const AddMenuSuccess(this.menus);

//   @override
//   List<Object> get props => [menus];
// }

// class AddMenuFailed extends AddMenuState {
//   final String error;

//   const AddMenuFailed(this.error);

//   @override
//   List<Object> get props => [error];
// }
