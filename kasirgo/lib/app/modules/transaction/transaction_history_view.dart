import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/printer_service.dart';
import '../../data/models/transaction_model.dart';

class TransactionHistoryView extends GetView<TransactionController> {
  @override
  Widget build(BuildContext context) {
    controller.loadTodayTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi Hari Ini'),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : controller.todayTransactions.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada transaksi hari ini',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.todayTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.todayTransactions[index];
                    return _buildTransactionCard(transaction);
                  },
                )),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No. Antrian: ${transaction.queueNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (transaction.customerName?.isNotEmpty ?? false)
                  Text(
                    transaction.customerName!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.formatRupiah(transaction.total ?? 0),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  transaction.payment?.method ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _formatDateTime(transaction.createdAt ?? ''),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Item:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...transaction.items!.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.quantity}x ${item.productName}'),
                          Text(CurrencyFormatter.formatRupiah(
                              item.subtotal ?? 0)),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text(CurrencyFormatter.formatRupiah(
                        transaction.subtotal ?? 0)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('PPN 11%:'),
                    Text(CurrencyFormatter.formatRupiah(
                        transaction.taxAmount ?? 0)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      CurrencyFormatter.formatRupiah(transaction.total ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Print receipt
                        Get.find<PrinterService>().printReceipt(transaction);
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Cetak Ulang'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    if (dateTime.isEmpty) return '';
    final dt = DateTime.parse(dateTime);
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
