import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pos_app/src/data/dataSources/remote/web/transaction_service.dart';
import 'package:pos_app/src/data/models/detail_transaction_model.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/src/data/models/transaction_model.dart';
// import 'package:intl/intl.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(const TransactionState()) {
    on<AddMenus>(_addMenus);
    on<SearchMenu>(_searchMenu);
    on<OrderIncrementPressed>(_orderIncrementPressed);
    on<OrderDecrementPressed>(_orderDecrementPressed);
    on<OrderCheckoutPressed>(_orderCheckoutPressed);
    on<OrderTypePaymentPressed>(_orderTypePaymentPressed);
    on<AddCashAndChangePayment>(_addCashAndChangePayment);
    on<AddBuyerName>(_addBuyerName);
    on<ResetState>(_resetState);
    on<AddTransaction>(_addTransaction);
    on<GetTransactionByID>(_getTransactionByID);
  }

  /// variabel untuk menampung menu yang ditambahkan
  final List<_Menu> _listMenuOrders = [];

  // bool _isfFromCart = false;
  // get isFromCart => _isfFromCart;
  // set setIsFromCart(bool newValue) {
  //   _isfFromCart = newValue;
  // }

  // CartModel _cart = const CartModel();
  // get cart => _cart;
  // set setCart(CartModel newValue) {
  //   _cart = newValue;
  // }

  int _totalPrice() {
    int totalPrice = 0;
    for (var item in _listMenuOrders) {
      totalPrice += item.price * item.totalBuy;
    }

    return totalPrice;
  }

  /// jika [_listMenuOrders] kosong atau variabel [index] -1
  /// return true
  bool _isCanAddToListMenuOrders(String id) {
    int index = _listMenuOrders.indexWhere((menu) => menu.id == id);
    if (_listMenuOrders.isEmpty || index == -1) {
      return true;
    }
    return false;
  }

  void _resetState(ResetState event, Emitter<TransactionState> emit) {
    _listMenuOrders.clear();
    emit(const TransactionState(
      id: '',
      buyer: '',
      cash: 0,
      change: 0,
      dateTimeOrder: null,
      menuOrders: null,
      listMenuSearch: null,
      total: 0,
      typePayment: '',
    ));
  }

  void _addMenus(AddMenus event, Emitter<TransactionState> emit) {
    if (_isCanAddToListMenuOrders(event.id)) {
      _listMenuOrders.add(
        _Menu(
          id: event.id,
          price: event.price,
          menuName: event.menuName,
          totalBuy: event.totalBuy,
          hpp: event.hpp,
          typeMenu: event.typeMenu,
          quantityStock: event.quantityStock,
          minimumQuantityStock: event.minimumQuantityStock,
          imageUrl: event.imageUrl,
        ),
      );
    }

    emit(state.copyWith(
      menuOrders: _listMenuOrders,
    ));
  }

  void _searchMenu(SearchMenu event, Emitter<TransactionState> emit) {
    List<_Menu>? menuSearch = state.menuOrders!.where(
      (menu) {
        return menu.menuName.toLowerCase().contains(event.query.toLowerCase());
      },
    ).toList();
    log('${menuSearch}');
    emit(state.copyWith(listMenuSearch: menuSearch));
  }

  _orderIncrementPressed(
      OrderIncrementPressed event, Emitter<TransactionState> emit) {
    int index = _listMenuOrders.indexWhere((menu) => menu.id == event.id);

    // increment total buy sesuai dengan data list menu order
    _listMenuOrders[index].totalBuy++;
    emit(state.copyWith(
      total: _totalPrice(),
      menuOrders: _listMenuOrders,
    ));
  }

  _orderDecrementPressed(
      OrderDecrementPressed event, Emitter<TransactionState> emit) {
    int index = _listMenuOrders.indexWhere((menu) => menu.id == event.id);

    // decrement total buy sesuai dengan data list menu order
    _listMenuOrders[index].totalBuy--;

    emit(state.copyWith(
      total: _totalPrice(),
      menuOrders: _listMenuOrders,
    ));
  }

  void _orderCheckoutPressed(
      OrderCheckoutPressed event, Emitter<TransactionState> emit) {
    DateTime dateTime = DateTime.now();

    /// format: year month day HOUR24_MINUTE_SECOND
    // String dateFormat = DateFormat('yyyMdHms').format(dateTime);
    // String id = 'oid$dateFormat';

    emit(state.copyWith(
      // id: id,
      dateTimeOrder: dateTime,
      menuOrders: _listMenuOrders,
    ));
  }

  void _orderTypePaymentPressed(
      OrderTypePaymentPressed event, Emitter<TransactionState> emit) {
    emit(state.copyWith(
      typePayment: event.typePayment,
    ));
  }

  void _addCashAndChangePayment(
      AddCashAndChangePayment event, Emitter<TransactionState> emit) {
    emit(state.copyWith(
      cash: event.cash,
      change: event.change,
    ));
  }

  // void _addOrderFromCart(
  //     AddOrderFromCart event, Emitter<TransactionState> emit) {
  //   log('event.menuOrders: ${event.menuOrders}');
  //   List<_Menu> menuOrders = event.menuOrders.map((order) {
  //     return _Menu(
  //       id: order.id,
  //       price: order.price,
  //       menuName: order.menuName,
  //       totalBuy: order.totalBuy,
  //       hpp: order.hpp,
  //       typeMenu: order.typeMenu,
  //       quantityStock: order.quantityStock,
  //       minimumQuantityStock: order.minimumQuantityStock,
  //     );
  //   }).toList();

  //   log('event.id: ${event.id}');
  //   emit(state.copyWith(
  //     id: event.id,
  //     buyer: event.buyer,
  //     menuOrders: menuOrders,
  //     dateTimeOrder: event.dateTimeOrder,
  //     total: event.total,
  //   ));
  // }

  void _addTransaction(
      AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      // hanya memasukan data yang total buy lebih dari 0
      List<DetailTransactionModel> detailTransactions = state.menuOrders!
          .where((order) => order.totalBuy != 0)
          .map((o) => DetailTransactionModel(
                menuId: o.id,
                totalBuy: o.totalBuy,
                amount: o.price * o.totalBuy,
              ))
          .toList();

      TransactionModel transaction = TransactionModel(
        buyer: state.buyer,
        pay: state.cash!,
        change: state.change!,
        detailTransactions: detailTransactions,
        total: state.total!,
        typePayment: state.typePayment,
      );

      // OrderService().addOrder(menuOrder);
      // CartService().deleteCart(menuOrder.id!);
      print('adeqw');

      TransactionModel transactionId =
          await TransactionService().addTransaction(transaction);
      print('adeqqwe');
      emit(state.copyWith(id: transactionId.id));

      log('sadasd ${state.id}');

      // TODO: buat update quantity menu
      // perulangan dari list menu untuk update quantity di database menu
      // for (var menu in listMenus) {
      //   StatusInventory status;
      //   int quantity = menu['quantityStock'] - menu['totalBuy'];

      //   if (quantity <= 0) {
      //     status = StatusInventory.outOfStock;
      //   } else if (quantity > menu['minimumQuantityStock']) {
      //     status = StatusInventory.inStock;
      //   } else {
      //     status = StatusInventory.lowStock;
      //   }
      //   // MenuService().updateQuantityAndStatus(
      //   //     menu['id'], quantity, StatusInventory.getValue(status));
      // }
    } catch (e) {
      print(e);
    }
  }

  void _getTransactionByID(
      GetTransactionByID event, Emitter<TransactionState> emit) async {
    try {
      log('sattdsda: ${state.id}');
      TransactionModel transaction =
          await TransactionService().getTransactionByID(state.id!);
      log('transactiondaa: ${transaction}');

      emit(state.copyWith(transaction: transaction));
    } catch (e) {
      print(e);
    }
  }

  void _addBuyerName(AddBuyerName event, Emitter<TransactionState> emit) {
    emit(state.copyWith(
      buyer: event.buyer,
    ));
  }
}
