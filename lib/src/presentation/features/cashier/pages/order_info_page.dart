import 'dart:developer';

import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/core/utils/string_helper.dart';
import '../index.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:pos_app/src/presentation/widgets/custom_divider.dart';
import 'package:pos_app/src/presentation/widgets/custom_list_tile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderInfoPage extends StatefulWidget {
  static const String routeName = '/order-info';

  const OrderInfoPage({super.key});

  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  TextEditingController buyerController = TextEditingController();
  bool isBuyerEmpty = false;
  late final TransactionBloc transactionBloc;

  @override
  void initState() {
    super.initState();
    transactionBloc = context.read<TransactionBloc>();

    // jika ada nama pembeli, maka text field tambahkan nama pembeli
    if (transactionBloc.state.buyer != null) {
      buyerController.text = transactionBloc.state.buyer!;
    }
  }

  // fungsi untuk tombol checkout
  void checkOutPressed() {
    Go.routeWithPath(context: context, path: Routes.paymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    // tampilan untuk text field pembeli
    Widget _buildCustomerInformation() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: primaryTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: buyerController,
                    onChanged: (value) {
                      if (isBuyerEmpty == true) {
                        setState(() {
                          isBuyerEmpty = false;
                        });
                      }
                      transactionBloc.add(
                        AddBuyerName(buyer: buyerController.text),
                      );
                    },
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 12,
                    ),
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      hintText: 'Customer Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      isBuyerEmpty ? "can't empty" : '',
                      style: redTextStyle.copyWith(
                        fontSize: 11,
                        fontWeight: light,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // tampilan untuk list menu yang di order atau di beli
    Widget _buildListMenu(List menuOrders) {
      int i = 0;
      List orders = menuOrders.where((order) => order.totalBuy != 0).toList();
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items',
              style: primaryTextStyle.copyWith(),
            ),
            Column(
              children: orders.map((menu) {
                i++;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomListTileMenu(
                      id: menu.id,
                      name: menu.menuName,
                      price: menu.price,
                      hpp: menu.hpp,
                      totalOrder: menu.totalBuy,
                      typeMenu: menu.typeMenu,
                      isDisabled: true,
                      quantityStock: menu.quantityStock,
                    ),
                    i != orders.length
                        ? const SizedBox(height: 12)
                        : const SizedBox(),
                    i != orders.length
                        ? const CustomDivider()
                        : const SizedBox(),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    // tampilan untuk total order
    Widget _buildOrderSummary(int total) {
      return Container(
        margin: const EdgeInsets.only(top: defaultMargin),
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: primaryTextStyle.copyWith(fontWeight: medium),
            ),
            Container(
              height: 42,
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightGray2Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: primaryTextStyle.copyWith(
                      fontWeight: light,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Rp. ${StringHelper.addComma(total)}',
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildButtonPayment() {
      return CustomButton(
        color: lightRedColor,
        onPressed: checkOutPressed,
        text: 'Payment',
        textStyle: whiteTextStyle.copyWith(fontSize: 12),
        margin: const EdgeInsets.only(
          right: 12,
          left: defaultMargin,
        ),
        // border: Border.all(width: 1, color: primaryColor),
      );
    }

    Widget body() {
      return SafeArea(
        child: Stack(
          children: [
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                log('state: ${state.menuOrders}');
                if (state.menuOrders != null) {
                  if (state.menuOrders!.isNotEmpty) {
                    return ListView(
                      children: [
                        const CustomAppBar(title: 'Order'),
                        _buildCustomerInformation(),
                        _buildListMenu(state.menuOrders!),
                        _buildOrderSummary(state.total!),
                        const SizedBox(
                          height: (defaultMargin * 2) + 55,
                        )
                      ],
                    );
                  } else {
                    return const Text('error please come back again');
                  }
                } else {
                  return const Text('error please come back again');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: defaultMargin,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildButtonPayment(),
              ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        context.read<TransactionBloc>().add(ResetState());
        // context.read<EditOrderFromCartBloc>().add(EditResetState());
        return true;
      },
      child: Scaffold(
        body: body(),
      ),
    );
  }
}
