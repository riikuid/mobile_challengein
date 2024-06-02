import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

class BankModel {
  final String kodeBank;
  final String namaBank;

  BankModel({
    required this.kodeBank,
    required this.namaBank,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        kodeBank: json["kodeBank"],
        namaBank: json["namaBank"],
      );
}
