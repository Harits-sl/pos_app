import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pos_app/src/core/utils/status_inventory.dart';
import 'package:pos_app/src/core/utils/string_helper.dart';
import 'package:pos_app/src/data/dataSources/remote/web/menu_service.dart';
import 'package:pos_app/src/data/models/menu_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  // String _id = '';
  // String _name = '';

  // set setId(String newValue) {
  //   _id = newValue;
  // }

  EditProductBloc() : super(const EditProductState()) {
    on<EditImage>(_editImage);
    on<EditNameChanged>(_onNameChanged);
    on<EditPriceChanged>(_onPriceChanged);
    on<EditHppChanged>(_onHppChanged);
    on<EditQuantityChanged>(_onQuantityChanged);
    on<EditMinimumQuantityChanged>(_onMinimumQuantityChanged);
    on<EditTypeProductChanged>(_onTypeProductChanged);
    on<FetchProductById>(_fetchProductById);
    on<EditClearState>(_onClearState);
    on<ButtonEditProductPressed>(_buttonEditProductPressed);
  }

  void _editImage(EditImage event, Emitter<EditProductState> emit) {
    emit(
      state.copyWith(
        status: EditStatus.edit,
        editImage: event.editImage,
      ),
    );
  }

  void _onNameChanged(EditNameChanged event, Emitter<EditProductState> emit) {
    emit(
      state.copyWith(
        status: EditStatus.edit,
        name: event.name,
      ),
    );
  }

  void _onPriceChanged(EditPriceChanged event, Emitter<EditProductState> emit) {
    emit(
      state.copyWith(
        status: EditStatus.edit,
        price: event.price,
      ),
    );
  }

  void _onHppChanged(EditHppChanged event, Emitter<EditProductState> emit) {
    emit(
      state.copyWith(
        status: EditStatus.edit,
        hpp: event.hpp,
      ),
    );
  }

  void _onQuantityChanged(
      EditQuantityChanged event, Emitter<EditProductState> emit) {
    emit(state.copyWith(
      status: EditStatus.edit,
      quantity: event.quantity,
    ));
  }

  void _onMinimumQuantityChanged(
    EditMinimumQuantityChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(
      state.copyWith(
        status: EditStatus.edit,
        minimumQuantity: event.minimumQuantity,
      ),
    );
  }

  void _onTypeProductChanged(
      EditTypeProductChanged event, Emitter<EditProductState> emit) {
    emit(
      state.copyWith(
        status: EditStatus.edit,
        typeMenu: event.typeProduct,
      ),
    );
  }

  _fetchProductById(event, Emitter<EditProductState> emit) async {
    try {
      emit(state.copyWith(status: EditStatus.loading));

      MenuModel menu = await MenuService().getMenuByID(event.id);

      emit(
        state.copyWith(
          id: menu.id,
          image: menu.image,
          name: menu.name,
          price: menu.price,
          hpp: menu.hpp,
          quantity: menu.quantity,
          minimumQuantity: menu.minimumQuantity,
          typeMenu: StringHelper.titleCase(menu.typeMenu),
          status: EditStatus.successFetch,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: EditStatus.failed,
        ),
      );
    }
  }

  void _onClearState(EditClearState event, Emitter<EditProductState> emit) {
    emit(
      state.copyWith(
        id: '',
        name: '',
        typeMenu: '',
        price: 0,
        hpp: 0,
        status: EditStatus.initial,
        message: '',
      ),
    );
  }

  void _buttonEditProductPressed(
      ButtonEditProductPressed event, Emitter<EditProductState> emit) async {
    try {
      // emit(AddMenuLoading());

      // String id = 'menu-${Random().nextInt(255)}';
      String id = state.id!;
      String? editImage = state.editImage;
      String name = state.name!;
      int price = state.price!;
      String typeProduct = state.typeMenu!;
      final int hpp = state.hpp!;
      final int quantity = state.quantity!;
      final int minimumQuantity = state.minimumQuantity!;

      MenuModel menuModel;
      if (editImage == null) {
        menuModel = MenuModel(
          id: id,
          name: name,
          typeMenu: typeProduct.toLowerCase(),
          price: price,
          hpp: hpp,
          quantity: quantity,
          minimumQuantity: minimumQuantity,
        );
      } else {
        menuModel = MenuModel(
          id: id,
          image: editImage,
          name: name,
          typeMenu: typeProduct.toLowerCase(),
          price: price,
          hpp: hpp,
          quantity: quantity,
          minimumQuantity: minimumQuantity,
        );
        log('MenuModel: ${menuModel.image}');
      }

      if (name == '') {
        emit(
          state.copyWith(
            status: EditStatus.failed,
            message: 'Nama Menu Kosong',
          ),
        );
        throw Exception(state.message);
      }

      if (price == 0) {
        emit(
          state.copyWith(
            status: EditStatus.failed,
            message: 'Harga Menu Kosong',
          ),
        );
        throw Exception(state.message);
      }

      MenuService().updateMenu(menuModel);
      emit(
        state.copyWith(
          status: EditStatus.successEdit,
          message: 'Success Edit Menu',
        ),
      );
    } catch (error) {
      debugPrint('error: $error');
      emit(
        state.copyWith(
          status: EditStatus.failed,
          message: error.toString(),
        ),
      );
    }
  }
}
