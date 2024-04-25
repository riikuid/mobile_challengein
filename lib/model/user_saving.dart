class UserSaving {
  final int countSavings;
  final int walletSavings;
  final int savingsRecord;
  final int savingsAmount;

  UserSaving({
    required this.countSavings,
    required this.walletSavings,
    required this.savingsRecord,
    required this.savingsAmount,
  });

  UserSaving copyWith({
    int? countSavings,
    int? walletSavings,
    int? savingsRecord,
    int? savingsAmount,
  }) =>
      UserSaving(
        countSavings: countSavings ?? this.countSavings,
        walletSavings: walletSavings ?? this.walletSavings,
        savingsRecord: savingsRecord ?? this.savingsRecord,
        savingsAmount: savingsAmount ?? this.savingsAmount,
      );

  factory UserSaving.fromJson(Map<String, dynamic> json) => UserSaving(
        countSavings: json["count_savings"],
        walletSavings: json["wallet_savings"],
        savingsRecord: json["savings_record"],
        savingsAmount: json["savings_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count_savings": countSavings,
        "wallet_savings": walletSavings,
        "savings_record": savingsRecord,
        "savings_amount": savingsAmount,
      };
}
