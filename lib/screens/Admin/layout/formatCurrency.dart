import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return format.format(amount);
}
