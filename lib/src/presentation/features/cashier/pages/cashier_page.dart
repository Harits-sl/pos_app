// import 'package:pos_app/src/data/models/cart_model.dart';

import 'package:pos_app/src/data/models/menu_model.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:pos_app/src/presentation/widgets/custom_card_menu.dart';
import 'package:pos_app/src/presentation/widgets/custom_divider.dart';

import '../../../../config/route/routes.dart';
import '../../../cubit/Menu/menu_cubit.dart';

import '../../../../data/models/menu_order_model.dart';
import '../index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/route/go.dart';
import '../../../../core/shared/theme.dart';
import '../../../../core/utils/string_helper.dart';
import '../../../widgets/custom_list_tile_menu.dart';

class CashierPage extends StatefulWidget {
  static const String routeName = '/cashier';

  // final BlueThermalPrinter printer;

  const CashierPage({
    // required this.printer,
    Key? key,
  }) : super(key: key);

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final TextEditingController _searchController = TextEditingController();

  List<MenuModel>? menus;
  // List<Map<String, dynamic>>? searchMenus;
  MenuOrderModel? menuOrder;
  late final MenuCubit menuCubit;
  late final TransactionBloc transactionBloc;
  bool isSearch = false;
  int totalOrder = 0;
  int totalOrderFromCart = 0;

  @override
  void initState() {
    super.initState();
    transactionBloc = context.read<TransactionBloc>();

    // menjalankan fungsi cubit json menu dan mengambil data menu
    menuCubit = context.read<MenuCubit>();
    menuCubit.getAllMenu();
  }

  @override
  void dispose() {
    _searchController.dispose();
    totalOrder = 0;
    super.dispose();
  }

  void _search(String query) {
    /// jika query pencarian tidak kosong maka variabel [isSearch] ubah true
    if (query.isNotEmpty) {
      isSearch = true;

      transactionBloc.add(SearchMenu(query: query));
      setState(() {});
    } else {
      isSearch = false;
      setState(() {});
    }
  }

  // fungsi untuk tombol checkout
  void checkOutPressed() {
    if (menuOrder!.total != 0) {
      transactionBloc.add(OrderCheckoutPressed());
      Go.routeWithPath(context: context, path: Routes.orderInfo);
    }
  }

  // fungsi tombol icon back
  void backPressed() {
    transactionBloc.add(ResetState());
    Go.back(context);
  }

  @override
  Widget build(BuildContext context) {
    // ambil data menu dari firebase
    menuCubit.getAllMenu();

    // membuat app bar
    Widget _buildAppBar() {
      return Container(
        padding: const EdgeInsets.all(defaultMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: backPressed,
              child: Image.asset(
                'assets/images/ic_back.png',
                width: 30,
              ),
            ),
            Text(
              'Cashier',
              style: primaryTextStyle.copyWith(
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(),
          ],
        ),
      );
    }

    // tampilan bar search
    Widget _buildSearch() {
      return Container(
        margin: const EdgeInsets.only(bottom: defaultMargin),
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: TextField(
          controller: _searchController,
          onSubmitted: (String query) {
            _search(query);
          },
          style: primaryTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 12,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            hintText: 'Search menu...',
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: ImageIcon(
                const AssetImage(
                  'assets/images/ic_search.png',
                ),
                size: 26,
                color: gray2Color,
              ),
            ),
          ),
        ),
      );
    }

    // tampilan membuat tampilan menu
    Widget _buildMenu() {
      Widget _menu(String title, List menus) {
        return menus.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      title,
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const CustomDivider(),
                  GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: (1 / 1.5),
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      children: menus
                          .map(
                            (menu) => CustomCardMenu(
                              key: Key(menu.id),
                              id: menu.id,
                              name: menu.menuName,
                              price: menu.price,
                              hpp: menu.hpp,
                              totalOrder: menu.totalBuy,
                              typeMenu: menu.typeMenu,
                              quantityStock: menu.quantityStock,
                              imageUrl: menu.imageUrl,
                            ),
                          )
                          .toList()),
                  // Column(
                  //   children: menus.map((menu) {
                  //     debugPrint('${menu.id}');

                  //     return Column(
                  //       children: [
                  //         CustomCardMenu(
                  //           key: Key(menu.id),
                  //           id: menu.id,
                  //           name: menu.menuName,
                  //           price: menu.price,
                  //           hpp: menu.hpp,
                  //           totalOrder: menu.totalBuy,
                  //           typeMenu: menu.typeMenu,
                  //           quantityStock: menu.quantityStock,
                  //         ),
                  //       ],
                  //     );
                  //   }).toList(),
                  // ),
                  const SizedBox(height: 16),
                ],
              );
      }

      return Container(
        margin: const EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: BlocListener<MenuCubit, MenuState>(
          listener: (context, state) {
            // jika berhasil ambil data menu, olah data tersebut
            if (state is MenuSuccess) {
              for (var menu in state.menu) {
                transactionBloc.add(
                  AddMenus(
                    id: menu.id!,
                    price: menu.price,
                    menuName: menu.name,
                    totalBuy: 0,
                    hpp: menu.hpp,
                    typeMenu: menu.typeMenu,
                    quantityStock: menu.quantity!,
                    minimumQuantityStock: menu.minimumQuantity!,
                    imageUrl: menu.image!,
                  ),
                );
              }
            }
          },
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              List? menuOrders; // variabel untuk list menu order

              // jika bukan pencarian pakai data list semua menu,
              // jika pencarian pakai data list pencarian
              if (!isSearch) {
                menuOrders = state.menuOrders;
              } else {
                menuOrders = state.listMenuSearch;
              }

              // jika menuOrders masih kosong, atau data sedang di ambil
              // maka tampilkan tampilan loading
              if (state.menuOrders == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
                // tampilan jika menuOrders data sudah ada
              } else if (state.menuOrders != null) {
                // list menu untuk lauk + nasi
                final List? listFoods = menuOrders!
                    .where((menu) => menu.typeMenu == 'food')
                    .toList();
                // list menu untuk lauk saja
                final List? listLauk = menuOrders
                    .where((menu) => menu.typeMenu == 'lauk')
                    .toList();
                // list menu untuk minuman
                final List? listDrinks = menuOrders
                    .where((menu) => menu.typeMenu == 'drink')
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _menu('Lauk + Nasi', listFoods!),
                    _menu('Lauk', listLauk!),
                    _menu('Minuman', listDrinks!),
                  ],
                );
              } else {
                return const Text('Please Try Again');
              }
            },
          ),
        ),
      );
    }

    // tampilan untuk membuat button checkout
    Widget _buttonCheckout() {
      return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          num totalBuy = 0;
          // MenuOrderModel menuOrder = const MenuOrderModel();
          if (state.menuOrders != null) {
            menuOrder = menuOrder = MenuOrderModel(
              listMenus: state.menuOrders,
              total: state.total ?? 0,
            );
            for (var item in menuOrder!.listMenus!) {
              totalBuy += item.totalBuy;
            }
          } else {
            menuOrder = const MenuOrderModel(
              id: '',
              listMenus: [],
              total: 0,
              dateTimeOrder: null,
            );
          }

          return CustomButtonWithIcon(
            color: totalBuy > 0 ? lightRedColor : gray2Color,
            onPressed: checkOutPressed,
            isShadowed: true,
            text: 'Your added $totalBuy items',
            iconUrl: 'assets/images/ic_bag.png',
            iconColor: totalBuy > 0 ? backgroundColor : primaryColor,
            iconText: 'Rp. ${StringHelper.addComma(menuOrder!.total)}',
            textStyle: totalBuy > 0
                ? white2TextStyle.copyWith(
                    fontSize: 12,
                  )
                : primaryTextStyle.copyWith(
                    fontSize: 12,
                  ),
          );
        },
      );
    }

    Widget _buildBody() {
      return SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                _buildAppBar(),
                _buildSearch(),
                _buildMenu(),
                // spasi dari menu ke widget checkout button
                const SizedBox(height: defaultMargin + 55),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buttonCheckout(),
            ),
          ],
        ),
      );
    }

    // willPopScope untuk jika tombol back di android ditekan
    return WillPopScope(
      onWillPop: () async {
        transactionBloc.add(ResetState());
        totalOrder = 0;
        totalOrderFromCart = 0;
        return true;
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }
}
