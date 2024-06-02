import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobile_challengein/model/savings_model.dart';

TopUpModel topUpModelFromJson(String str) =>
    TopUpModel.fromJson(json.decode(str));

String topUpModelToJson(TopUpModel data) => json.encode(data.toJson());

class TopUpModel {
  final String? id;
  final String? idSavings;
  final String? qrUrl;
  final bool? isExpired;
  final DateTime? qrExpired;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? topupAmount;
  final SavingModel? savings;
  // final SavingModel? saving;

  TopUpModel({
    this.id,
    this.idSavings,
    this.qrUrl,
    this.isExpired,
    this.qrExpired,
    this.createdAt,
    this.updatedAt,
    this.topupAmount,
    this.savings,
    // this.saving,
  });

  factory TopUpModel.fromJson(Map<String, dynamic> json) {
    int? parseTopupAmount(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value);
      }
      return 100;
    }

    return TopUpModel(
      id: json["id"],
      idSavings: json["id_savings"],
      qrUrl: json["qr_url"],
      isExpired: json["is_expired"],
      qrExpired: json["qr_expired"] == null
          ? null
          : DateFormat("yyyy-MM-dd HH:mm:ss Z").parse(json["qr_expired"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      topupAmount: parseTopupAmount(json["topup_amount"]),
      savings: SavingModel.fromJson(json["savings"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_savings": idSavings,
        "qr_url": qrUrl,
        "is_expired": isExpired,
        "qr_expired": qrExpired,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "topup_amount": topupAmount,
        "savings": savings?.toJson(),
      };
}
