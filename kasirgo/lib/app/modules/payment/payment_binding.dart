import 'package:get/get.dart';
import '../../controllers/transaction_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
    // Get.lazyPut<AuthController>(() => AuthController());
  }
}
