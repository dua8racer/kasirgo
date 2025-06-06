import 'package:get/get.dart';
import 'package:kasirgo_mobile/app/controllers/auth_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
