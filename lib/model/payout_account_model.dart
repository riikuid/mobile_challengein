import 'dart:convert';

PayoutAccountModel payoutAccountModelFromJson(String str) =>
    PayoutAccountModel.fromJson(json.decode(str));

class PayoutAccountModel {
  final String bankcode;
  final String bankname;
  final String accountnumber;
  final String accountname;

  PayoutAccountModel({
    required this.bankcode,
    required this.bankname,
    required this.accountnumber,
    required this.accountname,
  });

  factory PayoutAccountModel.fromJson(Map<String, dynamic> json) =>
      PayoutAccountModel(
        bankcode: json["bankcode"],
        bankname: json["bankname"],
        accountnumber: json["accountnumber"],
        accountname: json["accountname"],
      );
}
