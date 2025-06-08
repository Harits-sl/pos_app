import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:pos_app/src/data/models/transaction_model.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:pos_app/src/presentation/widgets/custom_divider.dart';
import 'package:flutter/services.dart';
import '../../../../config/route/go.dart';
import '../../../../config/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/shared/theme.dart';
import '../../../../core/utils/string_helper.dart';
import '../index.dart';

class ReceiptPage extends StatefulWidget {
  static const String routeName = '/receipt';

  const ReceiptPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  late String pathImage;
  late TransactionBloc transactionBloc;

  @override
  void initState() {
    super.initState();

    transactionBloc = context.read<TransactionBloc>();
  }

  Future<Uint8List> imagePathToUint8List(String path) async {
    //converting to Uint8List to pass to printer
    ByteData data = await rootBundle.load(path);
    Uint8List imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return imageBytes;
  }

  @override
  Widget build(BuildContext context) {
    // fungsi untuk tampilan struk
    void _receiptPrint(TransactionModel transaction) async {
      final BlueThermalPrinter printer =
          context.read<ThermalPrinterCubit>().printer!;
      // List menuOrders =
      //     transaction.detailTransactions!.where((order) => order.totalBuy != 0).toList();

      ///image from Asset
      ByteData bytesAsset =
          await rootBundle.load("assets/images/logo_print.png");
      Uint8List imageBytesFromAsset = bytesAsset.buffer
          .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

      //SIZE
      // 0- normal size text
      // 1- only bold text
      // 2- bold with medium text
      // 3- bold with large text
      //ALIGN
      // 0- ESC_ALIGN_LEFT
      // 1- ESC_ALIGN_CENTER
      // 2- ESC_ALIGN_RIGHT
      printer.isConnected.then((isConnected) async {
        String dateFormat =
            DateFormat('H:mm-M.d.yy').format(transaction.createdAt!);

        printer.printNewLine();
        printer.printCustom('Receipt', 3, 1);
        printer.printNewLine();
        printer.printImageBytes(imageBytesFromAsset);
        printer.printNewLine();
        printer.printCustom('RM. Harapan Bundo,', 1, 1);
        printer.printNewLine();
        printer.printCustom('Jl.Cempaka Putih Utara,RT.1/RW.8,', 0, 1);
        printer.printCustom('Harapan Mulya, Kec. Kemayoran,', 0, 1);
        printer.printCustom('Jakarta Pusat', 0, 1);
        printer.printCustom('10640', 0, 1);
        printer.printNewLine();
        printer.printCustom('--------------------------------', 0, 0);
        printer.printNewLine();
        transaction.buyer != '' && transaction.buyer != null
            ? printer.printLeftRight('Name', transaction.buyer!, 0)
            : '';
        printer.printLeftRight('Order ID', transaction.id!, 0);
        printer.printLeftRight('Date Order', dateFormat, 0);
        printer.printLeftRight('Payment Method', transaction.typePayment!, 0);
        printer.printNewLine();
        printer.printCustom('--------------------------------', 0, 0);
        for (var menu in transaction.detailTransactions!) {
          printer.printCustom(menu.name!, 0, 0);
          printer.printLeftRight(
            '${menu.totalBuy} x ${StringHelper.addComma(menu.price!)}',
            StringHelper.addComma(menu.amount),
            0,
          );
          printer.printNewLine();
        }
        printer.printCustom('--------------------------------', 0, 0);
        printer.printNewLine();
        printer.printLeftRight(
            'Total', StringHelper.addComma(transaction.total), 0);
        printer.printLeftRight(
            'Pay', StringHelper.addComma(transaction.pay), 0);
        printer.printLeftRight(
            'Change', StringHelper.addComma(transaction.change), 0);
        printer.printNewLine();
        printer.printNewLine();
        printer.paperCut();
      });
    }

    // fungsi untuk mencetak struk
    void onTapReceiptPrint(TransactionModel transaction) {
      if (context.read<ThermalPrinterCubit>().isConnected) {
        _receiptPrint(transaction);
      } else {
        Go.routeWithPath(context: context, path: Routes.selectPrinter);
      }
    }

    // fungsi untuk tombol ke home
    void _onTapBackToHome() {
      transactionBloc.add(ResetState());
      Go.routeWithPathAndRemoveUntil(
        context: context,
        path: Routes.home,
      );
      // Go.back(context);
      // Go.back(context);
      // Go.back(context);
      // Go.back(context);
      // Go.back(context);
    }

    // tampilan untuk order info atau receipt info
    Widget _buildReceiptInfo(TransactionModel transaction) {
      // List menuOrders =
      //     transaction.detailTransactions!.where((order) => order.totalBuy != 0).toList();
      String dateFormat = transaction.createdAt != null
          ? DateFormat('H:mm-M.d.yy').format(transaction.createdAt!)
          : 'hari kosong';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 80,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 240,
              child: Text(
                'RM. Harapan Bundo',
                style: primaryTextStyle.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 240,
              child: Text(
                'Jl. Cempaka Putih Utara, RT.1/RW.8, Harapan Mulya, Kec. Kemayoran, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10640',
                style: primaryTextStyle.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CustomDivider(),
            ),
            // jika nama buyer tidak hanya string kosong dan tidak null
            // maka tampilkan nama pembeli
            transaction.buyer != '' && transaction.buyer != null
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name',
                            style: primaryTextStyle.copyWith(
                              fontWeight: medium,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            transaction.buyer!,
                            style: primaryTextStyle.copyWith(
                              fontWeight: medium,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  )
                : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID',
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
                Text(
                  transaction.id!,
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date Order',
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
                Text(
                  dateFormat,
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method',
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
                Text(
                  transaction.typePayment!,
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CustomDivider(),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Menu',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'qty',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'price',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'amount',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: transaction.detailTransactions!
                  .map(
                    (order) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              order.name!,
                              style: primaryTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              order.totalBuy.toString(),
                              style: primaryTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              StringHelper.addComma(order.price!),
                              style: primaryTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              StringHelper.addComma(order.amount),
                              style: primaryTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const CustomDivider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  StringHelper.addComma(transaction.total),
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pay'),
                Text(
                  StringHelper.addComma(transaction.pay),
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Change'),
                Text(
                  StringHelper.addComma(transaction.change),
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // tampilan button back
    Widget _buildButtonBack() {
      return Expanded(
        child: CustomButton(
          color: backgroundColor,
          onPressed: () => _onTapBackToHome(),
          text: 'Back To Home',
          textStyle: primaryTextStyle.copyWith(fontSize: 12),
          margin: const EdgeInsets.only(
            right: 12,
            left: defaultMargin,
          ),
          border: Border.all(width: 1, color: lightRedColor),
        ),
      );
    }

    // tampilan button untuk cetak struk
    Widget _buildButtonPrintStruck(TransactionModel transaction) {
      return Expanded(
        child: CustomButton(
          color: lightRedColor,
          onPressed: () => onTapReceiptPrint(transaction),
          text: 'Print Receipt',
          margin: const EdgeInsets.only(right: defaultMargin, left: 12),
        ),
      );
    }

    Widget _buildBody() {
      return BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state.transaction == null) {
            transactionBloc.add(GetTransactionByID());
          }
        },
        builder: (context, state) {
          if (state.transaction != null) {
            TransactionModel transaction = state.transaction!;

            return Stack(
              children: [
                ListView(
                  children: [
                    const CustomAppBar(
                      title: 'Receipt',
                      isCanBack: false,
                    ),
                    _buildReceiptInfo(transaction),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: defaultMargin),
                    child: Row(
                      children: [
                        _buildButtonBack(),
                        _buildButtonPrintStruck(transaction),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          context.read<TransactionBloc>().add(ResetState());

          // Go.routeWithPathAndRemoveUntil(
          //   context: context,
          //   path: Routes.home,
          // );
          Go.back(context);
          Go.back(context);
          Go.back(context);
          Go.back(context);
          Go.back(context);
        },
        child: _buildBody(),
      ),
    );
  }
}
