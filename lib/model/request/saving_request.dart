import 'dart:convert';

String savingRequestToJson(SavingRequest data) => json.encode(data.toJson());

class SavingRequest {
  final String goalName;
  final String targetAmount;
  final DateTime targetDate;
  final String fillingNominal;
  final String fillingFrequency;
  final List<String> dayReminder;
  final String savingType;
  final int isReminder;
  final String timeReminder;
  final String fillingType;
  final String? pathImage;

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
    this.pathImage,
  });

  Map<String, String> toJson() => {
        "goal_name": goalName,
        "target_amount": targetAmount,
        "target_date":
            "${targetDate.year.toString().padLeft(4, '0')}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}",
        "filling_nominal": fillingNominal,
        "filling_frequency": fillingFrequency.toLowerCase(),
        "day_reminder": jsonEncode(dayReminder),
        "saving_type": savingType,
        "is_reminder": isReminder.toString(),
        "time_reminder": timeReminder,
        "filling_type": fillingType,
        "path_image": pathImage ?? "",
      };
}
