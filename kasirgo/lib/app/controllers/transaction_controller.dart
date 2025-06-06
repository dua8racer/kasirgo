import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/printer_service.dart';
import '../data/models/transaction_model.dart';
import '../data/services/transaction_service.dart';
import 'cart_controller.dart';
import 'session_controller.dart';

class TransactionController extends GetxController {
  final TransactionService _transactionService = Get.put(TransactionService());
  final PrinterService printerService = Get.find();
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

        final printerService = Get.find<PrinterService>();
        await printerService.printReceipt(transaction);
        // Clear cart
        _cartController.clearCart();

        // Return transaction for printing
        Get.back();

        Get.dialog(
          AlertDialog(
            title: const Text('Transaksi Berhasil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('No. Antrian: ${transaction.queueNumber}'),
                Text(
                    'Total: ${CurrencyFormatter.formatRupiah(transaction.total ?? 0)}'),
                const SizedBox(height: 16),
                const Text('Struk sedang dicetak...'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.offNamedUntil(
                      '/pos', (route) => route.settings.name == '/home');
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
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
