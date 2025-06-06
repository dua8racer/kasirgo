import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/session_controller.dart';
import '../../core/utils/currency_formatter.dart';

class CloseSessionView extends GetView<SessionController> {
  final endCashController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final session = controller.activeSession.value;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tutup Sesi')),
        body: const Center(
          child: Text('Tidak ada sesi aktif'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutup Sesi Kasir'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            width: 600,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ringkasan Sesi',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Session Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Modal Awal',
                            CurrencyFormatter.formatRupiah(
                                session.startCash ?? 0),
                          ),
                          const Divider(),
                          _buildSummaryRow(
                            'Total Penjualan',
                            CurrencyFormatter.formatRupiah(
                                session.totalSales ?? 0),
                          ),
                          _buildSummaryRow(
                            'Penjualan Tunai',
                            CurrencyFormatter.formatRupiah(
                                session.totalCashSales ?? 0),
                          ),
                          _buildSummaryRow(
                            'Penjualan Non-Tunai',
                            CurrencyFormatter.formatRupiah(
                                session.totalNonCash ?? 0),
                          ),
                          const Divider(),
                          _buildSummaryRow(
                            'Kas Seharusnya',
                            CurrencyFormatter.formatRupiah(
                              (session.startCash ?? 0) +
                                  (session.totalCashSales ?? 0),
                            ),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // End Cash Input
                    TextField(
                      controller: endCashController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Uang Tunai di Kasir',
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: 'Rp ',
                        helperText: 'Hitung semua uang tunai yang ada di kasir',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Notes
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        prefixIcon: Icon(Icons.note),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() => ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                        final endCash = double.tryParse(
                                                endCashController.text) ??
                                            0;
                                        if (endCash <= 0) {
                                          Get.snackbar(
                                            'Error',
                                            'Masukkan jumlah uang tunai di kasir',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                              'Apakah Anda yakin ingin menutup sesi kasir?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('Batal'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                  controller.closeSession(
                                                    endCash,
                                                    notesController.text,
                                                  );
                                                },
                                                child: const Text(
                                                    'Ya, Tutup Sesi'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text('Tutup Sesi'),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
