import 'package:bloc/bloc.dart';
import '../../../data/dataSources/remote/web/menu_service.dart';
import '../../../data/models/menu_model.dart';
import 'package:equatable/equatable.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial());

  void getAllMenu() async {
    try {
      emit(MenuLoading());
      // List<MenuModel> _listMenu = await MenuService().fetchMenu();
      List<MenuModel> _listMenu = await MenuService().getAllMenus();
      // List<MenuModel?> coffees = [], nonCoffees = [], foods = [];

      // for (var menu in _listMenu!) {
      //   if (menu.typeMenu == 'coffee') {
      //     coffees.add(menu);
      //   } else if (menu.typeMenu == 'non-coffee') {
      //     nonCoffees.add(menu);
      //   } else {
      //     foods.add(menu);
      //   }
      // }
      // List<MenuModel> coffees =
      //     _listMenu!.where((menu) => menu.typeMenu == 'coffee').toList();
      // List<MenuModel> nonCoffees =
      //     _listMenu!.where((menu) => menu.typeMenu == 'non-coffee').toList();
      // List<MenuModel> foods =
      //     _listMenu!.where((menu) => menu.typeMenu == 'food').toList();

      // List<Map<String, dynamic>> newListMenus = [
      //   {
      //     'typeMenu': 'Coffee',
      //     'menu': coffees,
      //   },
      //   {
      //     'typeMenu': 'Non Coffee',
      //     'menu': nonCoffees,
      //   },
      //   {
      //     'typeMenu': 'Foods',
      //     'menu': foods,
      //   },
      // ];

      emit(MenuSuccess(_listMenu));
    } catch (e) {
      emit(MenuFailed(e.toString()));
    }
  }

  // void searchMenu(String query) {
  //   List<MenuModel?> _listMenuSearch = [];

  //   for (MenuModel menu in _listMenu!) {
  //     if (menu.name.toLowerCase().contains(query.toLowerCase())) {
  //       _listMenuSearch.add(menu);
  //     }
  //   }

  //   List<Map<String, dynamic>> _newListMenus = [
  //     {
  //       'typeMenu': 'Result',
  //       'menu': _listMenuSearch,
  //     },
  //   ];

  //   emit(MenuSuccess(_newListMenus));

  //   // _listMenu!.contains(query);
  // }
}
