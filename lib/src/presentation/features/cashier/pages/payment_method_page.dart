import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:pos_app/src/presentation/widgets/custom_divider.dart';
import 'package:pos_app/src/presentation/widgets/order_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/theme.dart';
import '../index.dart';

class PaymentMethod extends StatelessWidget {
  static const String routeName = '/payment-method';

  const PaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionBloc = context.read<TransactionBloc>();

    // tambahkan jika diperlukan
    List<Map<String, String>> listPaymentOption = [
      {
        'title': 'Cash',
        'imageUrl': 'assets/images/ic_cash.png',
      },
      {
        'title': 'BNI',
        'imageUrl': 'assets/images/ic_bni.png',
      },
      // menambahkan pilihan pembayaran seperti di bawah ini
      // {
      //   'title': 'BNI',
      //   'imageUrl': 'assets/images/imageUrl.png',
      // },
    ];

    // tampilan untuk payment option
    Widget _buildPaymentOption(int total) {
      return Column(
        children: listPaymentOption
            .map((paymentOption) => GestureDetector(
                  onTap: () {
                    transactionBloc.add(
                      OrderTypePaymentPressed(
                        typePayment: paymentOption['title']!,
                      ),
                    );

                    Go.routeWithPath(
                        context: context, path: Routes.paymentAmount);
                  },
                  child: Container(
                    height: 62,
                    margin: const EdgeInsets.only(
                      bottom: 12,
                      left: defaultMargin,
                      right: defaultMargin,
                    ),
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.5, color: lightGray2Color),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          paymentOption['imageUrl']!,
                          width: 35,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          paymentOption['title']!,
                          style: primaryTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    }

    Widget _buildBody() {
      return SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(title: 'Payment Method'),
                  OrderInformation(
                    // orderId: state.id!,
                    total: state.total!,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: defaultMargin,
                      vertical: 12,
                    ),
                    child: const CustomDivider(),
                  ),
                  // const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultMargin),
                    child: Text(
                      'Pilih Pembayaran',
                      style: primaryTextStyle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(state.total!),
                ],
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: _buildBody(),
    );
  }
}
