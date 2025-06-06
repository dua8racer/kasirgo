import 'package:get/get.dart';
import '../data/models/transaction_model.dart';
import '../data/services/transaction_service.dart';
import 'cart_controller.dart';
import 'session_controller.dart';

class TransactionController extends GetxController {
  final TransactionService _transactionService = Get.put(TransactionService());
  final CartController _cartController = Get.find();
  final SessionController _sessionController = Get.find();

  final isLoading = false.obs;
  final todayTransactions = <TransactionModel>[].obs;
  final selectedPaymentMethod = 'cash'.obs;

  Future<void> createTransaction({
    required String paymentMethod,
    required double amountReceived,
  }) async {
    if (_cartController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Keranjang belanja kosong');
      return;
    }

    if (_sessionController.activeSession.value == null) {
      Get.snackbar('Error', 'Tidak ada sesi aktif');
      return;
    }

    isLoading.value = true;
    try {
      final transactionData = {
        'session_id': _sessionController.activeSession.value!.id,
        'customer_name': _cartController.customerName.value,
        'items':
            _cartController.cartItems.map((item) => item.toJson()).toList(),
        'tax_id': null, // Default tax ID
        'payment_method': paymentMethod,
        'amount_received': amountReceived,
        'notes': _cartController.notes.value,
      };

      final response =
          await _transactionService.createTransaction(transactionData);

      if (response.statusCode == 201) {
        final transaction = TransactionModel.fromJson(response.body);
        todayTransactions.add(transaction);
        Get.snackbar(
          'Berhasil',
          'Transaksi berhasil dibuat',
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        // Clear cart
        _cartController.clearCart();

        // Return transaction for printing
        Get.back(result: transaction);
      } else {
        Get.snackbar(
            'Error', response.body['error'] ?? 'Gagal membuat transaksi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTodayTransactions() async {
    if (_sessionController.activeSession.value == null) return;

    isLoading.value = true;
    try {
      final response = await _transactionService.getTransactionsBySession(
        _sessionController.activeSession.value!.id!,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        todayTransactions.value =
            data.map((e) => TransactionModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
