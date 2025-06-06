import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/printer_service.dart';

class PaymentView extends GetView<TransactionController> {
  final CartController cartController = Get.find();
  final amountReceivedController = TextEditingController();
  final PrinterService printerService = Get.put(PrinterService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Row(
        children: [
          // Order Summary
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Pesanan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Customer Name
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nama Pelanggan (Opsional)',
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) =>
                        cartController.customerName.value = value,
                  ),
                  const SizedBox(height: 16),

                  // Order Items
                  Expanded(
                    child: Card(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartController.cartItems[index];
                          return ListTile(
                            title: Text(item.productName ?? ''),
                            subtitle: Text(
                                '${item.quantity} x ${CurrencyFormatter.formatRupiah(item.price ?? 0)}'),
                            trailing: Text(
                              CurrencyFormatter.formatRupiah(item.subtotal),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Notes
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Catatan (Opsional)',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 2,
                    onChanged: (value) => cartController.notes.value = value,
                  ),
                ],
              ),
            ),
          ),

          // Payment Section
          Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Metode Pembayaran',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // Payment Methods
                Obx(() => Column(
                      children: [
                        _buildPaymentMethod(
                          'cash',
                          'Tunai',
                          Icons.money,
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethod(
                          'qris',
                          'QRIS',
                          Icons.qr_code,
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethod(
                          'card',
                          'Kartu Debit/Kredit',
                          Icons.credit_card,
                          Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethod(
                          'ewallet',
                          'E-Wallet',
                          Icons.account_balance_wallet,
                          Colors.purple,
                        ),
                      ],
                    )),

                const SizedBox(height: 24),

                // Amount Input (for cash)
                Obx(() => controller.selectedPaymentMethod.value == 'cash'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: amountReceivedController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Jumlah Diterima',
                              prefixIcon: const Icon(Icons.attach_money),
                              prefixText: 'Rp ',
                              suffixIcon: TextButton(
                                onPressed: () {
                                  amountReceivedController.text =
                                      cartController.total.toStringAsFixed(0);
                                },
                                child: const Text('Uang Pas'),
                              ),
                            ),
                            onChanged: (value) {
                              // Update change amount
                            },
                          ),
                          const SizedBox(height: 16),

                          // Quick amount buttons
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              50000,
                              100000,
                              150000,
                              200000,
                            ]
                                .map((amount) => OutlinedButton(
                                      onPressed: () {
                                        amountReceivedController.text =
                                            amount.toString();
                                      },
                                      child: Text(
                                          CurrencyFormatter.formatRupiah(
                                              amount.toDouble())),
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 16),

                          // Change amount
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.yellow[700]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Kembalian:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _calculateChange(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()),

                const Spacer(),

                // Total Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text(CurrencyFormatter.formatRupiah(
                              cartController.subtotal)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('PPN 11%:'),
                          Text(CurrencyFormatter.formatRupiah(
                              cartController.tax)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatRupiah(
                                cartController.total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Process Payment Button
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => _processPayment(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Proses Pembayaran',
                              style: TextStyle(fontSize: 18),
                            ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
      String value, String label, IconData icon, Color color) {
    return InkWell(
      onTap: () => controller.selectedPaymentMethod.value = value,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.selectedPaymentMethod.value == value
                ? color
                : Colors.grey[300]!,
            width: controller.selectedPaymentMethod.value == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: controller.selectedPaymentMethod.value == value
              ? color.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: controller.selectedPaymentMethod.value == value
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateChange() {
    if (amountReceivedController.text.isEmpty) {
      return CurrencyFormatter.formatRupiah(0);
    }

    final amountReceived = double.tryParse(amountReceivedController.text) ?? 0;
    final change = amountReceived - cartController.total;

    return CurrencyFormatter.formatRupiah(change);
  }

  void _processPayment() async {
    double amountReceived = cartController.total;

    if (controller.selectedPaymentMethod.value == 'cash') {
      if (amountReceivedController.text.isEmpty) {
        Get.snackbar('Error', 'Masukkan jumlah uang yang diterima');
        return;
      }

      amountReceived = double.tryParse(amountReceivedController.text) ?? 0;

      if (amountReceived < cartController.total) {
        Get.snackbar('Error', 'Jumlah uang tidak mencukupi');
        return;
      }
    }

    await controller.createTransaction(
      paymentMethod: controller.selectedPaymentMethod.value,
      amountReceived: amountReceived,
    );

    // If transaction successful, it will navigate back with transaction data
    // The transaction data can be used for printing receipt
  }
}
