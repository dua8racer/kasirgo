import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatRupiah(double amount) {
    return _formatter.format(amount);
  }

  static double parseRupiah(String formatted) {
    final cleanString = formatted.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanString) ?? 0;
  }
}
