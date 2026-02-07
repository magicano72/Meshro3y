import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
  
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
}

class DateFormatter {
  static String format(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
