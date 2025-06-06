part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const POS = _Paths.POS;
  static const PAYMENT = _Paths.PAYMENT;
  static const START_SESSION = _Paths.START_SESSION;
  static const CLOSE_SESSION = _Paths.CLOSE_SESSION;
  static const TRANSACTION_HISTORY = _Paths.TRANSACTION_HISTORY;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const POS = '/pos';
  static const PAYMENT = '/payment';
  static const START_SESSION = '/start-session';
  static const CLOSE_SESSION = '/close-session';
  static const TRANSACTION_HISTORY = '/transaction-history';
}
