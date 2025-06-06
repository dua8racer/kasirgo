import 'package:get/get.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/transaction_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionController>(() => SessionController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    // Get.lazyPut<AuthController>(() => AuthController());
  }
}
