import 'package:get/get.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/pos/pos_binding.dart';
import '../modules/pos/pos_view.dart';
import '../modules/payment/payment_binding.dart';
import '../modules/payment/payment_view.dart';
import '../modules/session/session_binding.dart';
import '../modules/session/start_session_view.dart';
import '../modules/session/close_session_view.dart';
import '../modules/transaction/transaction_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.POS,
      page: () => PosView(),
      binding: PosBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.START_SESSION,
      page: () => StartSessionView(),
      binding: SessionBinding(),
    ),
    GetPage(
      name: _Paths.CLOSE_SESSION,
      page: () => CloseSessionView(),
      binding: SessionBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_HISTORY,
      page: () => TransactionHistoryView(),
    ),
  ];
}
