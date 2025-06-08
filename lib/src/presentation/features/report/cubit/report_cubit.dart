import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pos_app/src/core/utils/date.dart';
import 'package:pos_app/src/data/dataSources/remote/web/report_service.dart';
import 'package:pos_app/src/data/models/detail_transaction_model.dart';
import 'package:pos_app/src/data/models/menu_order_model.dart';
import 'package:pos_app/src/data/models/transaction_model.dart';
import 'package:pos_app/src/presentation/features/report/report_order.dart';
import 'package:equatable/equatable.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  int _seluruhTotalMinuman = 0;
  int _seluruhTotalMakanan = 0;
  int _seluruhJumlahMinumanTerjual = 0;
  int _seluruhJumlahMakananTerjual = 0;
  int _seluruhLabaMinuman = 0;
  int _seluruhLabaMakanan = 0;
  int _seluruhLabaBersihMinuman = 0;
  int _seluruhLabaBersihMakanan = 0;
  int _totalseluruhLabaBersih = 0;
  int _idRadio = 1;

  int get seluruhTotalMinuman => _seluruhTotalMinuman;
  int get seluruhTotalMakanan => _seluruhTotalMakanan;
  int get seluruhJumlahMinumanTerjual => _seluruhJumlahMinumanTerjual;
  int get seluruhJumlahMakananTerjual => _seluruhJumlahMakananTerjual;
  int get seluruhLabaMinuman => _seluruhLabaMinuman;
  int get seluruhLabaMakanan => _seluruhLabaMakanan;
  int get seluruhLabaBersihMinuman => _seluruhLabaBersihMinuman;
  int get seluruhLabaBersihMakanan => _seluruhLabaBersihMakanan;
  int get totalseluruhLabaBersih => _totalseluruhLabaBersih;
  int get idRadio => _idRadio;

  set setIdRadio(int value) {
    _idRadio = value;
  }

  void initState() {
    _seluruhTotalMinuman = 0;
    _seluruhTotalMakanan = 0;
    _seluruhJumlahMinumanTerjual = 0;
    _seluruhJumlahMakananTerjual = 0;
    _seluruhLabaMinuman = 0;
    _seluruhLabaMakanan = 0;
    _seluruhLabaBersihMinuman = 0;
    _seluruhLabaBersihMakanan = 0;
    _totalseluruhLabaBersih = 0;
  }

  void fetchReportOrderToday() async {
    emit(ReportLoading());
    try {
      List<TransactionModel> transactions = await ReportService().getToday();
      emit(ReportSuccess(_addDataReport(transactions)));
    } catch (e) {
      emit(ReportFailed(e.toString()));
    }
  }

  void fetchReportOrderThisMonth() async {
    emit(ReportLoading());
    try {
      List<TransactionModel> transactions =
          await ReportService().getThisMonth();
      emit(ReportSuccess(_addDataReport(transactions)));
    } catch (e) {
      emit(ReportFailed(e.toString()));
    }
  }

  void fetchReportDateOrder(DateTime firstDate, DateTime endDate) async {
    emit(ReportLoading());
    try {
      List<TransactionModel> transactions =
          await ReportService().getCustom(firstDate, endDate);
      emit(ReportSuccess(_addDataReport(transactions)));
    } catch (e) {
      emit(ReportFailed(e.toString()));
    }
  }

  List<ReportOrder> _addDataReport(List<TransactionModel> transactions) {
    return transactions.map(
      (transaction) {
        int totalMinuman = 0;
        int totalMakanan = 0;
        int jumlahMinumanTerjual = 0;
        int jumlahMakananTerjual = 0;
        int labaMinuman = 0;
        int labaMakanan = 0;

        addToDrink(DetailTransactionModel menu) {
          totalMinuman += menu.totalBuy;
          jumlahMinumanTerjual += (menu.price! * menu.totalBuy);
          labaMinuman += (menu.hpp! * menu.totalBuy);
        }

        addToFood(DetailTransactionModel menu) {
          totalMakanan += menu.totalBuy;
          jumlahMakananTerjual += (menu.price! * menu.totalBuy);
          labaMakanan += (menu.hpp! * menu.totalBuy);
        }

        for (DetailTransactionModel detail in transaction.detailTransactions!) {
          if (detail.typeMenu == 'drink') {
            addToDrink(detail);
          } else if (detail.typeMenu == 'food') {
            addToFood(detail);
          }
        }

        int labaBersihMinuman = jumlahMinumanTerjual - labaMinuman;
        int labaBersihMakanan = jumlahMakananTerjual - labaMakanan;
        int labaBersihSeluruh = labaBersihMinuman + labaBersihMakanan;

        _seluruhTotalMinuman += totalMinuman;
        _seluruhTotalMakanan += totalMakanan;
        _seluruhJumlahMinumanTerjual += jumlahMinumanTerjual;
        _seluruhJumlahMakananTerjual += jumlahMakananTerjual;
        _seluruhLabaMinuman += labaMinuman;
        _seluruhLabaMakanan += labaMakanan;
        _seluruhLabaBersihMinuman += labaBersihMinuman;
        _seluruhLabaBersihMakanan += labaBersihMakanan;
        _totalseluruhLabaBersih += labaBersihSeluruh;

        return ReportOrder(
          id: transaction.id!,
          tanggal: Date.format(transaction.createdAt!),
          totalMinuman: totalMinuman,
          totalMakanan: totalMakanan,
          jumlahMinumanTerjual: jumlahMinumanTerjual,
          jumlahMakananTerjual: jumlahMakananTerjual,
          labaMinuman: labaMinuman,
          labaMakanan: labaMakanan,
          labaBersihMinuman: labaBersihMinuman,
          labaBersihMakanan: labaBersihMakanan,
          labaBersihSeluruh: labaBersihSeluruh,
        );
      },
    ).toList();
  }
}
