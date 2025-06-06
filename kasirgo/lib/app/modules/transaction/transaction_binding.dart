import 'package:get/get.dart';
import 'package:kasirgo_mobile/app/controllers/auth_controller.dart';
import 'package:kasirgo_mobile/app/controllers/cart_controller.dart';
import 'package:kasirgo_mobile/app/controllers/transaction_controller.dart';

import '../../core/utils/printer_service.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<PrinterService>(() => PrinterService());
  }
}
