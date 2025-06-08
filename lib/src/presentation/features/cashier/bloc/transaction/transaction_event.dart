part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class AddMenus extends TransactionEvent {
  final String id;
  final int price;
  final String menuName;
  final int totalBuy;
  final int hpp;
  final String typeMenu;
  final int quantityStock;
  final int minimumQuantityStock;
  final String? imageUrl;

  const AddMenus({
    required this.id,
    required this.price,
    required this.menuName,
    required this.totalBuy,
    required this.hpp,
    required this.typeMenu,
    required this.quantityStock,
    required this.minimumQuantityStock,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        price,
        menuName,
        totalBuy,
        hpp,
        typeMenu,
        quantityStock,
        minimumQuantityStock,
        imageUrl,
      ];
}

class OrderIncrementPressed extends TransactionEvent {
  final String id;

  const OrderIncrementPressed({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchMenu extends TransactionEvent {
  final String query;

  const SearchMenu({required this.query});

  @override
  List<Object> get props => [query];
}

class OrderDecrementPressed extends TransactionEvent {
  final String id;

  const OrderDecrementPressed({required this.id});

  @override
  List<Object> get props => [id];
}

class OrderCheckoutPressed extends TransactionEvent {}

class OrderTypePaymentPressed extends TransactionEvent {
  final String typePayment;

  const OrderTypePaymentPressed({
    required this.typePayment,
  });
  @override
  List<Object> get props => [typePayment];
}

class AddCashAndChangePayment extends TransactionEvent {
  final int cash;
  final int change;
  const AddCashAndChangePayment({
    required this.cash,
    required this.change,
  });

  @override
  List<Object> get props => [cash, change];
}

class AddBuyerName extends TransactionEvent {
  final String? buyer;
  const AddBuyerName({
    this.buyer,
  });

  @override
  List<Object?> get props => [buyer];
}

class AddOrderFromCart extends TransactionEvent {
  final String id;
  final List menuOrders;
  final int total;
  final DateTime dateTimeOrder;
  final String buyer;

  const AddOrderFromCart({
    required this.id,
    required this.menuOrders,
    required this.total,
    required this.dateTimeOrder,
    required this.buyer,
  });

  @override
  List<Object?> get props => [
        id,
        menuOrders,
        total,
        dateTimeOrder,
        buyer,
      ];
}

class ResetState extends TransactionEvent {}

class AddTransaction extends TransactionEvent {}

class GetTransactionByID extends TransactionEvent {}
