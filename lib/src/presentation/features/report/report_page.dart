import 'dart:developer';
import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_app/src/core/utils/string_helper.dart';
import 'package:pos_app/src/presentation/features/report/report_order.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:pos_app/src/presentation/widgets/custom_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import 'helper/save_to_mobile.dart' as helper;

import 'index.dart';
import 'data_row/report_data_source.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);
  static const String routeName = '/report';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  DateTime? firstDate;
  DateTime? secondDate;
  late Timestamp firstTimestamp;
  late Timestamp secondTimestamp;
  late ReportCubit reportCubit;

  @override
  void initState() {
    super.initState();

    firstDate = DateTime.now();
    secondDate = DateTime.now();

    reportCubit = context.read<ReportCubit>();
    reportCubit.setIdRadio = 1;
    fetchReportOrder();
    // reportCubit.fetchReportOrderToday();
  }

  @override
  void dispose() {
    super.dispose();
    reportCubit.initState();
  }

  // ambil data report order sesuai dengan yang dipilih
  fetchReportOrder() {
    switch (reportCubit.idRadio) {
      case 1:
        reportCubit.fetchReportOrderToday();
        break;
      case 2:
        reportCubit.fetchReportOrderThisMonth();
        break;
      default:
        reportCubit.fetchReportOrderToday();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _itemProfit(
      String title,
      int total,
      Color color,
      IconData icon,
    ) {
      return Container(
        width: 135,
        height: 135,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
            ),
            const SizedBox(height: defaultMargin),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: grayTextStyle.copyWith(
                    fontSize: 11,
                    fontWeight: light,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rp. ${StringHelper.addComma(total)}',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget gridProfit() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _itemProfit(
                  'Food Sales',
                  reportCubit.seluruhLabaBersihMakanan,
                  reportColor3,
                  Icons.food_bank_outlined,
                ),
                _itemProfit(
                  'Beverage Sales',
                  reportCubit.seluruhLabaBersihMinuman,
                  reportColor4,
                  Icons.emoji_food_beverage_outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _itemProfit(
                  'Total Profit',
                  reportCubit.totalseluruhLabaBersih,
                  reportColor1,
                  Icons.monetization_on_outlined,
                ),
              ],
            ),
          ],
        ),
      );
    }

    // tampilan report custom date
    Widget _buildDatePickerCustom() {
      Widget _datePickerItem({
        DateTime? fromDate,
        DateTime? toDate,
      }) {
        DateTime selectInitialDate() {
          if (fromDate != null) {
            return fromDate;
          } else if (toDate != null) {
            return toDate;
          } else {
            return DateTime.now();
          }
        }

        DateTime initialDate = selectInitialDate();

        return GestureDetector(
          child: Row(
            children: [
              Text(
                fromDate != null
                    ? 'From ${StringHelper.dateFormat(firstDate!)}'
                    : 'To ${StringHelper.dateFormat(secondDate!)}',
                style: primaryTextStyle,
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/ic_date.png',
                width: 22,
                color: primaryColor,
              ),
            ],
          ),
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2099),
              currentDate: DateTime.now(),
            ).then((date) {
              setState(() {
                if (date != null) {
                  if (fromDate != null) {
                    firstDate = date;
                  } else {
                    secondDate = date;
                  }
                }
              });
            });
          },
        );
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(defaultMargin, 12, defaultMargin, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _datePickerItem(fromDate: firstDate),
            const SizedBox(height: 8),
            _datePickerItem(toDate: secondDate),
            CustomButton(
              margin: const EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              width: 150,
              height: 40,
              color: primaryColor,
              text: 'Search',
              onPressed: () {
                reportCubit.initState();
                context
                    .read<ReportCubit>()
                    .fetchReportDateOrder(firstDate!, secondDate!);
              },
            ),
          ],
        ),
      );
    }

    // tampilan untuk pilihan report yang diinginkan
    Widget _buildDatePicker() {
      Widget _datePickerItem(int id, String title) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              reportCubit.initState();
              reportCubit.setIdRadio = id;
              fetchReportOrder();
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: reportCubit.idRadio == id
                    ? backgroundColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                title,
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: lightGray2Color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            _datePickerItem(1, 'Today'),
            _datePickerItem(2, 'This Month'),
            _datePickerItem(3, 'Custom'),
          ],
        ),
      );
    }

    Future<dynamic> onTapExportToExcel() async {
      final fileName = 'report-${DateTime.now()}';
      final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();
      // await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
      final Directory directory = await getApplicationDocumentsDirectory();
      File file =
          await File('${directory.path}/$fileName.xlsx').writeAsBytes(bytes);
      log('file: ${file}');

      try {
        // dynamic text = await file.readAsBytes();
        OpenFilex.open('${directory.path}/$fileName.xlsx');
        // log('text: ${text}');
        // return text;
      } catch (e) {
        log('e: ${e}');
      }
      // workbook.dispose();
    }

    Widget exportToExcelButton() {
      return CustomButton(
        color: redColor,
        onPressed: onTapExportToExcel,
        text: 'Export To Excel',
      );
    }

    // tampilan table report
    Widget tableSfDataGrid(List<ReportOrder> orders) {
      return CustomTable(
        keySfDataFrid: _key,
        frozenColumnsCount: 2,
        columnWidthMode: ColumnWidthMode.auto,
        source: ReportDataSource(
          reportOrders: orders,
          reportCubit: reportCubit,
        ),
        columns: [
          columnItem('no', 'No.'),
          columnItem('tanggal', 'Tanggal'),
          columnItem('totalMinuman', 'Total Minuman'),
          columnItem('totalMakanan', 'Total Makanan'),
          columnItem('jumlahMinumanTerjual', 'Jumlah Minuman Terjual'),
          columnItem('jumlahMakananTerjual', 'Jumlah Makanan Terjual'),
          columnItem('labaMinuman', 'Laba Minuman'),
          columnItem('labaMakanan', 'Laba Makanan'),
          columnItem('labaBersihMinuman', 'Laba Bersih Minuman'),
          columnItem('labaBersihMakanan', 'Laba Bersih Makanan'),
          columnItem('labaBersihSeluruh', 'Laba Bersih Seluruh'),
        ],
      );
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          reportCubit.initState();
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const CustomAppBar(title: 'Report'),
                _buildDatePicker(),
                const SizedBox(height: 12),
                BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    if (state is ReportSuccess) {
                      return Column(
                        children: [
                          reportCubit.idRadio == 3
                              ? _buildDatePickerCustom()
                              : const SizedBox(),
                          gridProfit(),
                          exportToExcelButton(),
                          const SizedBox(height: 12),
                          tableSfDataGrid(state.orders),
                        ],
                      );
                    } else if (state is ReportLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ReportFailed) {
                      return Text(state.error);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
