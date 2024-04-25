class HistoryModel {
  String id;
  String idSavings;
  String typeTrx;
  String statusTrx;
  int amountMoney;
  DateTime createdAt;
  DateTime updatedAt;

  HistoryModel({
    required this.id,
    required this.idSavings,
    required this.typeTrx,
    required this.statusTrx,
    required this.amountMoney,
    required this.createdAt,
    required this.updatedAt,
  });

  HistoryModel copyWith({
    String? id,
    String? idSavings,
    String? typeTrx,
    String? statusTrx,
    int? amountMoney,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      HistoryModel(
        id: id ?? this.id,
        idSavings: idSavings ?? this.idSavings,
        typeTrx: typeTrx ?? this.typeTrx,
        statusTrx: statusTrx ?? this.statusTrx,
        amountMoney: amountMoney ?? this.amountMoney,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        id: json["id"],
        idSavings: json["id_savings"],
        typeTrx: json["type_trx"],
        statusTrx: json["status_trx"],
        amountMoney: json["amount_money"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_savings": idSavings,
        "type_trx": typeTrx,
        "status_trx": statusTrx,
        "amount_money": amountMoney,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
