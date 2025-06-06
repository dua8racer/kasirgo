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
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body:
          isMobile ? _buildMobileLayout(context) : _buildTabletLayout(context),
    );
  }

  // Mobile Layout - Single column
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Order Summary Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Pesanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Name
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nama Pelanggan (Opsional)',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      cartController.customerName.value = value,
                ),
                const SizedBox(height: 16),

                // Order Items Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Items',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${cartController.totalItems} item',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const Divider(),
                        ...cartController.cartItems.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${item.quantity} x ${CurrencyFormatter.formatRupiah(item.price ?? 0)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatRupiah(
                                        item.subtotal),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Catatan (Opsional)',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) => cartController.notes.value = value,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Payment Methods Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Obx(() => Column(
                      children: [
                        _buildPaymentMethodCard(
                          'cash',
                          'Tunai',
                          Icons.money,
                          Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentMethodCard(
                          'qris',
                          'QRIS',
                          Icons.qr_code,
                          Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentMethodCard(
                          'card',
                          'Kartu Debit/Kredit',
                          Icons.credit_card,
                          Colors.orange,
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentMethodCard(
                          'ewallet',
                          'E-Wallet',
                          Icons.account_balance_wallet,
                          Colors.purple,
                        ),
                      ],
                    )),

                const SizedBox(height: 16),

                // Cash Amount Input
                Obx(() => controller.selectedPaymentMethod.value == 'cash'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: amountReceivedController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah Diterima',
                              prefixIcon: Icon(Icons.attach_money),
                              prefixText: 'Rp ',
                              border: OutlineInputBorder(),
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
                              _buildQuickAmountButton(50000),
                              _buildQuickAmountButton(100000),
                              _buildQuickAmountButton(150000),
                              _buildQuickAmountButton(200000),
                              OutlinedButton(
                                onPressed: () {
                                  amountReceivedController.text =
                                      cartController.total.toStringAsFixed(0);
                                },
                                child: const Text('Uang Pas'),
                              ),
                            ],
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _calculateChange(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()),
              ],
            ),
          ),

          // Total Summary - Sticky at bottom
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                const SizedBox(height: 16),

                // Process Payment Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => _processPayment(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Proses Pembayaran',
                                style: TextStyle(fontSize: 18),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tablet Layout - Original split screen
  Widget _buildTabletLayout(BuildContext context) {
    return Row(
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
          child: _buildPaymentContent(),
        ),
      ],
    );
  }

  Widget _buildPaymentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Metode Pembayaran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
                              child: Text(CurrencyFormatter.formatRupiah(
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
                  Text(CurrencyFormatter.formatRupiah(cartController.subtotal)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PPN 11%:'),
                  Text(CurrencyFormatter.formatRupiah(cartController.tax)),
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
                    CurrencyFormatter.formatRupiah(cartController.total),
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
              onPressed:
                  controller.isLoading.value ? null : () => _processPayment(),
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
    );
  }

  Widget _buildPaymentMethodCard(
      String value, String label, IconData icon, Color color) {
    return InkWell(
      onTap: () => controller.selectedPaymentMethod.value = value,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.selectedPaymentMethod.value == value
                ? color
                : Colors.grey[300]!,
            width: controller.selectedPaymentMethod.value == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: controller.selectedPaymentMethod.value == value
              ? color.withOpacity(0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: controller.selectedPaymentMethod.value == value
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (controller.selectedPaymentMethod.value == value)
              Icon(Icons.check_circle, color: color),
          ],
        ),
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

  Widget _buildQuickAmountButton(int amount) {
    return OutlinedButton(
      onPressed: () {
        amountReceivedController.text = amount.toString();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(CurrencyFormatter.formatRupiah(amount.toDouble())),
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
