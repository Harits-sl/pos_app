import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/data/dataSources/remote/web/report_service.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/src/data/dataSources/remote/web/user_service.dart';
import 'package:pos_app/src/data/models/transaction_model.dart';
import 'package:pos_app/src/data/models/user_model.dart';

part 'home_state.dart';

enum DateStatus { today, yesterday, oneWeek, oneMonth }

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // void fetchUserByID(String id) async {
  //   try {
  //     emit(HomeLoading());
  //     UserModel user = await UserService().getUserByID(id);
  //     emit(HomeSuccess(incomeList));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void fetchTransactionAndUser() async {
    try {
      emit(HomeLoading());

      int incomeToday = totalOrder(await ReportService().getToday());
      int incomeYesterday = totalOrder(await ReportService().getYesterday());
      int incomeOneWeek = totalOrder(await ReportService().getThisWeek());
      int incomeOneMonth = totalOrder(await ReportService().getThisMonth());

      String role = await SessionManager().get("role");
      log('role: ${role}');

      // UserModel? user;
      // if (id != null) {
      //   user = await UserService().getUserByID(id);
      //   log('user: ${user}');
      // }

      Map<DateStatus, int> incomeList = {
        DateStatus.today: incomeToday,
        DateStatus.yesterday: incomeYesterday,
        DateStatus.oneWeek: incomeOneWeek,
        DateStatus.oneMonth: incomeOneMonth
      };

      emit(HomeSuccess(incomeList, role));
    } catch (e) {
      emit(HomeFailed(e.toString()));
    }
  }

  int totalOrder(List<TransactionModel> transactions) {
    int total = 0;

    for (var transaction in transactions) {
      total += transaction.total;
    }
    return total;
  }
}
