import 'package:intl/intl.dart';

String formatDateToString(DateTime date) {
  final format = DateFormat('dd MMMM yyyy');
  return format.format(date);
}
