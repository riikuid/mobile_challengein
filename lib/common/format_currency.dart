import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return formatCurrency.format(amount);
}
