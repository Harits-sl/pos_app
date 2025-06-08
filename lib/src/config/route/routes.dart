import 'package:pos_app/src/presentation/features/cashier/index.dart';
import 'package:pos_app/src/presentation/features/home/home_page.dart';
import 'package:pos_app/src/presentation/features/product/index.dart';
import 'package:pos_app/src/presentation/features/report/index.dart';
import 'package:pos_app/src/presentation/features/splash/splah_page.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/features/user/pages/add_user_page.dart';
import 'package:pos_app/src/presentation/features/user/pages/edit_user_page.dart';
import 'package:pos_app/src/presentation/features/user/pages/login_page.dart';

class Routes {
  static const String splash = SplashPage.routeName;
  static const String home = HomePage.routeName;
  static const String login = LoginPage.routeName;
  static const String product = ProductPage.routeName;
  static const String cashier = CashierPage.routeName;
  static const String user = UserPage.routeName;
  static const String addUser = AddUserPage.routeName;
  static const String editUser = EditUserPage.routeName;
  static const String receipt = ReceiptPage.routeName;
  static const String paymentAmount = PaymentAmountPage.routeName;
  static const String paymentMethod = PaymentMethod.routeName;
  static const String selectPrinter = '/select-printer';
  static const String addProduct = AddProductPage.routeName;
  static const String orderInfo = OrderInfoPage.routeName;
  static const String report = ReportPage.routeName;
}
