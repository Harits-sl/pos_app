import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pos_app/src/core/utils/status_inventory.dart';
import 'package:pos_app/src/data/dataSources/remote/web/menu_service.dart';
import 'package:pos_app/src/data/models/menu_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(const AddProductState()) {
    on<AddImage>(_addImage);
    on<NameChanged>(_onNameChanged);
    on<PriceChanged>(_onPriceChanged);
    on<HppChanged>(_onHppChanged);
    on<QuantityChanged>(_onQuantityChanged);
    on<MinimumQuantityChanged>(_onMinimumQuantityChanged);
    on<TypeProductChanged>(_onTypeProductChanged);
    on<ButtonAddProductPressed>(_onButtonProductPressed);
    on<ClearState>(_onClearState);
  }

  void _addImage(AddImage event, Emitter<AddProductState> emit) {
    emit(
      state.copyWith(
        image: event.image,
      ),
    );
  }

  void _onNameChanged(NameChanged event, Emitter<AddProductState> emit) {
    emit(
      state.copyWith(
        name: event.name,
      ),
    );
  }

  void _onPriceChanged(PriceChanged event, Emitter<AddProductState> emit) {
    emit(
      state.copyWith(
        price: event.price,
      ),
    );
  }

  void _onHppChanged(HppChanged event, Emitter<AddProductState> emit) {
    emit(
      state.copyWith(
        hpp: event.hpp,
      ),
    );
  }

  void _onQuantityChanged(
      QuantityChanged event, Emitter<AddProductState> emit) {
    emit(state.copyWith(quantity: event.quantity));
  }

  void _onMinimumQuantityChanged(
    MinimumQuantityChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(
      state.copyWith(minimumQuantity: event.minimumQuantity),
    );
  }

  void _onTypeProductChanged(
      TypeProductChanged event, Emitter<AddProductState> emit) {
    log('event.typeProduct: ${event.typeProduct}');
    emit(
      state.copyWith(
        typeProduct: event.typeProduct,
      ),
    );
  }

  void _onButtonProductPressed(
      ButtonAddProductPressed event, Emitter<AddProductState> emit) async {
    try {
      // emit(AddProductLoading());

      // String id = 'menu-${Random().nextInt(255)}';
      String image = state.image;
      String name = state.name;
      int price = state.price;
      String typeProduct = state.typeProduct;
      final int hpp = state.hpp;
      final int quantity = state.quantity;
      final int minimumQuantity = state.minimumQuantity;
      StatusInventory status;

      if (quantity <= 0) {
        status = StatusInventory.outOfStock;
      } else if (quantity > minimumQuantity) {
        status = StatusInventory.inStock;
      } else {
        status = StatusInventory.lowStock;
      }

      MenuModel menuModel = MenuModel(
        image: image,
        name: name,
        typeMenu: typeProduct.toLowerCase(),
        price: price,
        hpp: hpp,
        quantity: quantity,
        minimumQuantity: minimumQuantity,
        status: status,
      );

      if (name == '') {
        emit(
          state.copyWith(
            status: Status.failed,
            message: 'Nama Produk Kosong',
          ),
        );
        throw Exception(state.message);
      }

      if (price == 0) {
        emit(
          state.copyWith(
            status: Status.failed,
            message: 'Harga Produk Kosong',
          ),
        );
        throw Exception(state.message);
      }

      if (hpp == 0) {
        emit(
          state.copyWith(
            status: Status.failed,
            message: 'hpp Produk Kosong',
          ),
        );
        throw Exception(state.message);
      }

      MenuService().addMenu(menuModel);
      emit(
        state.copyWith(
          status: Status.success,
          message: 'Success Add Product',
        ),
      );
    } catch (error) {
      debugPrint('error: $error');
      emit(
        state.copyWith(
          status: Status.failed,
          message: error.toString(),
        ),
      );
    }
  }

  void _onClearState(ClearState event, Emitter<AddProductState> emit) {
    emit(
      state.copyWith(
        image: '',
        name: '',
        typeProduct: '',
        price: 0,
        hpp: 0,
        status: Status.initial,
        message: '',
      ),
    );
  }
}
