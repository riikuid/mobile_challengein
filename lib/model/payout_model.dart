// To parse this JSON data, do
//
//     final payoutModel = payoutModelFromJson(jsonString);

import 'dart:convert';

import 'package:mobile_challengein/model/savings_model.dart';

PayoutModel payoutModelFromJson(String str) =>
    PayoutModel.fromJson(json.decode(str));

class PayoutModel {
  final String id;
  final String idSavings;
  final String norek;
  final String nameRekening;
  final int amountMoney;
  final String statusPayouts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SavingModel savings;

  PayoutModel({
    required this.id,
    required this.idSavings,
    required this.norek,
    required this.nameRekening,
    required this.amountMoney,
    required this.statusPayouts,
    required this.createdAt,
    required this.updatedAt,
    required this.savings,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) => PayoutModel(
        id: json["id"],
        idSavings: json["id_savings"],
        norek: json["norek"],
        nameRekening: json["name_rekening"],
        amountMoney: json["amount_money"],
        statusPayouts: json["status_payouts"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        savings: SavingModel.fromJson(json["savings"]),
      );
}
