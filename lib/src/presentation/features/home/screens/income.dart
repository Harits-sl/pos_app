import 'package:flutter/material.dart';

import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/core/utils/string_helper.dart';

import '../index.dart';

class Income extends StatelessWidget {
  const Income({
    required this.totalList,
    Key? key,
  }) : super(key: key);

  final Map<DateStatus, int>? totalList;

  @override
  Widget build(BuildContext context) {
    // membuat item dari total income
    Widget totalIncome(
      String title,
      int total, [
      bool isToday = false,
    ]) {
      return Column(
        children: [
          Text(
            title,
            style: primaryTextStyle.copyWith(
              fontWeight: regular,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            StringHelper.addComma(total),
            style: isToday
                ? secondaryTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  )
                : primaryTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.all(defaultMargin),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        // color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: grayColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Center(
              child: Text(
                'Income',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    totalIncome(
                      'Today',
                      totalList == null ? 0 : totalList![DateStatus.today]!,
                      true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    totalIncome(
                        'This Week',
                        totalList == null
                            ? 0
                            : totalList![DateStatus.oneWeek]!),
                  ],
                ),
                Column(
                  children: [
                    totalIncome(
                        'Yesterday',
                        totalList == null
                            ? 0
                            : totalList![DateStatus.yesterday]!),
                    const SizedBox(
                      height: 16,
                    ),
                    totalIncome(
                        'This Month',
                        totalList == null
                            ? 0
                            : totalList![DateStatus.oneMonth]!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
