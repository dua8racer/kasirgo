import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import 'currency_formatter.dart';

class PrinterService extends GetxService {
  // This is a placeholder for IMIN printer integration
  // In real implementation, you would use IMIN SDK

  Future<void> printReceipt(TransactionModel transaction) async {
    try {
      // Format receipt content
      final receipt = _formatReceipt(transaction);

      // TODO: Integrate with IMIN printer SDK
      // For now, just print to console
      print(receipt);

      Get.snackbar('Info', 'Struk sedang dicetak...');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mencetak struk: $e');
    }
  }

  String _formatReceipt(TransactionModel transaction) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('================================');
    buffer.writeln('        KASIRGO F&B');
    buffer.writeln('    Jl. Contoh No. 123');
    buffer.writeln('     Tel: 021-1234567');
    buffer.writeln('================================');
    buffer.writeln();

    // Transaction info
    buffer.writeln('No. Antrian: ${transaction.queueNumber}');
    buffer.writeln('Tanggal: ${_formatDate(transaction.createdAt!)}');
    buffer.writeln('Kasir: ${transaction.userId}');
    if (transaction.customerName?.isNotEmpty ?? false) {
      buffer.writeln('Pelanggan: ${transaction.customerName}');
    }
    buffer.writeln('--------------------------------');

    // Items
    for (var item in transaction.items!) {
      buffer.writeln('${item.productName}');
      buffer.writeln(
          '  ${item.quantity} x ${CurrencyFormatter.formatRupiah(item.price!)}');
      buffer.writeln('  = ${CurrencyFormatter.formatRupiah(item.subtotal!)}');
    }

    buffer.writeln('--------------------------------');

    // Totals
    buffer.writeln(
        'Subtotal: ${CurrencyFormatter.formatRupiah(transaction.subtotal!)}');
    buffer.writeln(
        'PPN 11%: ${CurrencyFormatter.formatRupiah(transaction.taxAmount!)}');
    buffer.writeln(
        'Total: ${CurrencyFormatter.formatRupiah(transaction.total!)}');

    buffer.writeln('--------------------------------');

    // Payment
    buffer.writeln(
        'Bayar (${transaction.payment!.method}): ${CurrencyFormatter.formatRupiah(transaction.payment!.amountReceived!)}');
    if (transaction.payment!.method == 'cash') {
      buffer.writeln(
          'Kembali: ${CurrencyFormatter.formatRupiah(transaction.payment!.change!)}');
    }

    buffer.writeln('================================');
    buffer.writeln('    Terima kasih');
    buffer.writeln('  Selamat menikmati');
    buffer.writeln('================================');

    return buffer.toString();
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }
}
