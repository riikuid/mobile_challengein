import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challengein/model/filter_model.dart';
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
    final format = DateFormat('dd MMM yyyy');
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

  static String formatRangeDate(
      {required DateTime? startDate, required DateTime? endDate}) {
    if (startDate != null && endDate != null) {
      return "${formatDateToString(startDate)} - ${formatDateToString(endDate)}";
    } else if (startDate == null && endDate != null) {
      return "<= ${formatDateToString(endDate)}";
    } else if (startDate != null && endDate == null) {
      return ">= ${formatDateToString(startDate)}";
    }
    return '-';
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

  static Color getColorBasedOnStatusWD(String status) {
    status = status.toUpperCase(); // Case-insensitive comparison

    switch (status) {
      case 'SUCCESS':
        return greenLableColor;
      case 'PROCESS':
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

  static String formatConditionFilter(GoalNameCondition? condition) {
    switch (condition) {
      case GoalNameCondition.contains:
        return "Contains";
      case GoalNameCondition.doesntContain:
        return "Doesn't contain";
      case GoalNameCondition.iss:
        return "Is";
      case GoalNameCondition.isNot:
        return "Is not";
      case GoalNameCondition.startsWith:
        return "Starts with";
      case GoalNameCondition.endsWith:
        return "Ends with";
      default:
        return "-";
    }
  }

  static String formatRangeAmount(
      {required int? amount1, required int? amount2}) {
    if (amount1 == 0 && amount2 == 100000000) {
      return '-';
    } else if (amount2 == null && amount1 != null) {
      return '>= ${formatCurrency(amount1)}';
    } else if (amount1 == null && amount2 != null) {
      return '<= ${formatCurrency(amount2)}';
    } else {
      return "${formatCurrency(amount1!)} - ${formatCurrency(amount2!)}";
    }
  }
}
