// To parse this JSON data, do
//
//     final payoutRequest = payoutRequestFromJson(jsonString);

import 'dart:convert';

PayoutRequest payoutRequestFromJson(String str) =>
    PayoutRequest.fromJson(json.decode(str));

String payoutRequestToJson(PayoutRequest data) => json.encode(data.toJson());

class PayoutRequest {
  final String idSavings;
  final String norek;
  final String nameRekening;
  final String amountMoney;
  final String bankName;

  PayoutRequest({
    required this.idSavings,
    required this.norek,
    required this.nameRekening,
    required this.amountMoney,
    required this.bankName,
  });

  factory PayoutRequest.fromJson(Map<String, dynamic> json) => PayoutRequest(
        idSavings: json["id_savings"],
        norek: json["norek"],
        nameRekening: json["name_rekening"],
        amountMoney: json["amount_money"],
        bankName: json["bank_name"],
      );

  Map<String, dynamic> toJson() => {
        "id_savings": idSavings,
        "norek": norek,
        "name_rekening": nameRekening,
        "amount_money": amountMoney,
        "bank_name": bankName,
      };
}
