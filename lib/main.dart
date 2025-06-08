import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pos_app/src/presentation/features/cashier/index.dart';
import 'package:pos_app/src/presentation/features/product/index.dart';
import 'package:pos_app/src/presentation/features/splash/splah_page.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/features/user/pages/add_user_page.dart';
import 'package:pos_app/src/presentation/features/user/pages/edit_user_page.dart';
import 'src/config/route/routes.dart';
import 'src/presentation/cubit/Menu/menu_cubit.dart';
import 'src/presentation/features/home/index.dart';
import 'src/presentation/features/report/index.dart';

import 'src/config/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// final dbHelper = DatabaseHelper();

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<UserCubit>(
          create: (BuildContext context) => UserCubit(),
        ),
        BlocProvider<AddUserBloc>(
          create: (BuildContext context) => AddUserBloc(),
        ),
        BlocProvider<EditUserBloc>(
          create: (BuildContext context) => EditUserBloc(),
        ),
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => HomeCubit(),
        ),
        BlocProvider<ProductCubit>(
          create: (BuildContext context) => ProductCubit(),
        ),
        BlocProvider<TransactionBloc>(
          create: (BuildContext context) => TransactionBloc(),
        ),
        BlocProvider<MenuCubit>(
          create: (BuildContext context) => MenuCubit(),
        ),
        BlocProvider<ThermalPrinterCubit>(
          create: (BuildContext context) => ThermalPrinterCubit(),
        ),
        BlocProvider<AddProductBloc>(
          create: (BuildContext context) => AddProductBloc(),
        ),
        BlocProvider<EditProductBloc>(
          create: (BuildContext context) => EditProductBloc(),
        ),
        BlocProvider<ReportCubit>(
          create: (BuildContext context) => ReportCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          Routes.splash: (context) => const SplashPage(),
          Routes.login: (context) => const LoginPage(),
          Routes.home: (context) => const HomePage(),
          Routes.cashier: (context) => const CashierPage(),
          Routes.product: (context) => const ProductPage(),
          Routes.paymentAmount: (context) => const PaymentAmountPage(),
          Routes.paymentMethod: (context) => const PaymentMethod(),
          Routes.receipt: (context) => const ReceiptPage(),
          Routes.selectPrinter: (context) => const SelectPrinterPage(),
          Routes.addProduct: (context) => const AddProductPage(),
          Routes.report: (context) => const ReportPage(),
          Routes.orderInfo: (context) => const OrderInfoPage(),
          Routes.user: (context) => const UserPage(),
          Routes.addUser: (context) => const AddUserPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            // case HomePage.routeName:
            //   final String? userID = settings.arguments == null
            //       ? null
            //       : settings.arguments as String;
            //   return MaterialPageRoute(
            //     builder: (_) => HomePage(userID: userID),
            //     settings: settings,
            //   );
            case EditProductPage.routeName:
              final String id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => EditProductPage(id: id),
                settings: settings,
              );

            case EditUserPage.routeName:
              final String id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => EditUserPage(id: id),
                settings: settings,
              );

            default:
          }
          // Other values need to be implemented if we
          // add them. The assertion here will help remind
          // us of that higher up in the call stack, since
          // this assertion would otherwise fire somewhere
          // in the framework.
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}
