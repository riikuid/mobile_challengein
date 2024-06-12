import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challengein/theme.dart';

class AppHelper {
  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  static String formatCurrencyNominal(int amount) {
    final formatCurrency = NumberFormat.currency(
      // locale: 'id_ID',
      // symbol: 'Rp',
      symbol: "",
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  static String formatDateToString(DateTime date) {
    final format = DateFormat('dd MMMM yyyy');
    return format.format(date);
  }

  static String formatDateTimeWithWIB(DateTime dateTime) {
    // Format date to "dd MMMM yyyy HH:mm" format
    final DateFormat formatter = DateFormat('dd MMMM yyyy HH:mm', 'en_US');
    String formatted = formatter.format(dateTime);

    // Add "WIB" timezone manually
    return '$formatted WIB';
  }

  static String formatDateTimeToWIB(DateTime dateTime) {
    // Format the time as hh:mm
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return '$formattedTime WIB';
  }

  static Duration getDurationDifference({
    required DateTime start,
    required DateTime end,
  }) {
    return start.difference(end);
  }

  static String truncateWdId(String input) {
    if (input.length <= 10) {
      return input; // No need to truncate if the string is already short
    }

    // Extract the first 5 and the last 5 characters
    String start = input.substring(0, 5);
    String end = input.substring(input.length - 5);

    // Combine them with '...' in between
    return '$start...$end';
  }

  static Color getColorBasedOnStatus(String status) {
    status = status.toUpperCase(); // Case-insensitive comparison

    switch (status) {
      case 'SUCCESS':
        return greenLableColor;
      case 'PENDING':
        return orangeLableColor;
      case 'FAILED':
        return redLableColor;
      default:
        return blackColor;
    }
  }

  static String formatDatePostHistory(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
