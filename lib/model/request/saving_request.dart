import 'dart:convert';

import 'package:mobile_challengein/model/savings_model.dart';

String savingRequestToJson(SavingRequest data) => json.encode(data.toJson());

class SavingRequest {
  final String goalName;
  final String targetAmount;
  final DateTime targetDate;
  final String fillingNominal;
  final String fillingFrequency;
  final List<String> dayReminder;
  final SavingType savingType;
  final int isReminder;
  final String timeReminder;
  final String fillingType;

  SavingRequest({
    required this.goalName,
    required this.targetAmount,
    required this.targetDate,
    required this.fillingNominal,
    required this.fillingFrequency,
    required this.dayReminder,
    required this.savingType,
    required this.isReminder,
    required this.timeReminder,
    required this.fillingType,
  });

  Map<String, String> toJson() => {
        "goal_name": goalName,
        "target_amount": targetAmount,
        "target_date":
            "${targetDate.year.toString().padLeft(4, '0')}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}",
        "filling_nominal": fillingNominal,
        "filling_frequency": fillingFrequency.toLowerCase(),
        "day_reminder": jsonEncode(dayReminder),
        "saving_type": savingType == SavingType.record
            ? "savings_record"
            : "wallet_savings",
        "is_reminder": isReminder.toString(),
        "time_reminder": timeReminder,
        "filling_type": fillingType,
      };
}
