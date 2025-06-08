import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/presentation/features/home/bloc/home_cubit.dart';

class Shortcut extends StatelessWidget {
  const Shortcut({
    Key? key,
    required this.role,
  }) : super(key: key);

  final String? role;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width / 2;

    void _onTapCashier() {
      Go.routeWithPath(context: context, path: Routes.cashier);
    }

    void _onTapProducts() {
      Go.routeWithPath(context: context, path: Routes.product);
    }

    void _onTapReports() {
      Go.routeWithPath(context: context, path: Routes.report);
    }

    void _onTapUsers() {
      Go.routeWithPath(context: context, path: Routes.user);
    }

    Widget item(String title, String imageUrl, Function()? onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: _width - (defaultMargin * 2),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: lightGray2Color,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Image.asset(
                imageUrl,
                width: 40,
                height: 40,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: primaryTextStyle.copyWith(
                  fontSize: 11,
                  fontWeight: light,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: role != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Shortcuts to manage POS',
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
                role == 'pelayan'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          item(
                            'Cashier',
                            'assets/images/ic_cashier.png',
                            _onTapCashier,
                          ),
                          item(
                            'Products',
                            'assets/images/ic_product.png',
                            _onTapProducts,
                          ),
                        ],
                      )
                    : const SizedBox(),
                // const SizedBox(
                //   height: 16,
                // ),
                role == 'pemilik'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          item(
                            'Reports',
                            'assets/images/ic_report.png',
                            _onTapReports,
                          ),
                          item(
                            'Users',
                            'assets/images/ic_add_user.png',
                            _onTapUsers,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            )
          : const SizedBox(),
    );
  }
}
