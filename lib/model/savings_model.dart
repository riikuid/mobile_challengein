import 'dart:convert';

enum SavingType { wallet, record }

SavingModel savingModelFromJson(String str) =>
    SavingModel.fromJson(json.decode(str));

class SavingModel {
  final String id;
  final String idUser;
  final String goalName;
  final int savingAmount;
  final int targetAmount;
  final String pathImage;
  final DateTime targetDate;
  final int fillingNominal;
  final String fillingFrequency;
  final int fillingEstimation;
  final List<String> dayReminder;
  final String timeReminder;
  final bool isDone;
  final SavingType savingType;
  final bool isReminder;
  final String fillingType;
  final double progressSavings;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavingModel({
    required this.id,
    required this.idUser,
    required this.goalName,
    required this.savingAmount,
    required this.targetAmount,
    required this.pathImage,
    required this.targetDate,
    required this.fillingNominal,
    required this.fillingFrequency,
    required this.fillingEstimation,
    required this.dayReminder,
    required this.timeReminder,
    required this.isDone,
    required this.savingType,
    required this.isReminder,
    required this.fillingType,
    required this.progressSavings,
    required this.createdAt,
    required this.updatedAt,
  });

  SavingModel copyWith({
    String? id,
    String? idUser,
    String? goalName,
    int? savingAmount,
    int? targetAmount,
    String? pathImage,
    DateTime? targetDate,
    int? fillingNominal,
    String? fillingFrequency,
    int? fillingEstimation,
    List<String>? dayReminder,
    String? timeReminder,
    bool? isDone,
    SavingType? savingType,
    bool? isReminder,
    String? fillingType,
    double? progressSavings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      SavingModel(
        id: id ?? this.id,
        idUser: idUser ?? this.idUser,
        goalName: goalName ?? this.goalName,
        savingAmount: savingAmount ?? this.savingAmount,
        targetAmount: targetAmount ?? this.targetAmount,
        pathImage: pathImage ?? this.pathImage,
        targetDate: targetDate ?? this.targetDate,
        fillingNominal: fillingNominal ?? this.fillingNominal,
        fillingFrequency: fillingFrequency ?? this.fillingFrequency,
        fillingEstimation: fillingEstimation ?? this.fillingEstimation,
        dayReminder: dayReminder ?? this.dayReminder,
        timeReminder: timeReminder ?? this.timeReminder,
        isDone: isDone ?? this.isDone,
        savingType: savingType ?? this.savingType,
        isReminder: isReminder ?? this.isReminder,
        fillingType: fillingType ?? this.fillingType,
        progressSavings: progressSavings ?? this.progressSavings,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SavingModel.fromJson(Map<String, dynamic> json) => SavingModel(
        id: json["id"],
        idUser: json["id_user"],
        goalName: json["goal_name"],
        savingAmount: json["saving_amount"] ?? 0,
        targetAmount: json["target_amount"],
        pathImage: json["path_image"],
        targetDate: DateTime.parse(json["target_date"]),
        fillingNominal: json["filling_nominal"],
        fillingFrequency: json["filling_frequency"],
        fillingEstimation: json["filling_estimation"],
        dayReminder: json["day_reminder"] is List
            ? List<String>.from(json["day_reminder"].map((x) => x))
            : (json["day_reminder"]).toString().split(", "),
        timeReminder: json["time_reminder"],
        isDone: json["is_done"],
        savingType: json["saving_type"] == "savings_record"
            ? SavingType.record
            : SavingType.wallet,
        isReminder: json["is_reminder"],
        fillingType: json["filling_type"],
        progressSavings: double.parse(json["progress_savings"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "goal_name": goalName,
        "saving_amount": savingAmount,
        "target_amount": targetAmount,
        "path_image": pathImage,
        "target_date": targetDate.toIso8601String(),
        "filling_nominal": fillingNominal,
        "filling_frequency": fillingFrequency,
        "filling_estimation": fillingEstimation,
        "day_reminder": dayReminder,
        "time_reminder": timeReminder,
        "is_done": isDone,
        "saving_type": savingType == SavingType.record
            ? "savings_record"
            : "wallet_savings",
        "is_reminder": isReminder ? 1 : 0,
        "filling_type": fillingType,
        "progress_savings": progressSavings.toString(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
