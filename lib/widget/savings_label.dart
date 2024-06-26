// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_challengein/theme.dart';

class SavingsTypeLable extends StatelessWidget {
  final String savingsType;
  const SavingsTypeLable({
    super.key,
    required this.savingsType,
  });

  @override
  Widget build(BuildContext context) {
    String lable = "";
    Color backgroundColor = disabledColor;
    switch (savingsType) {
      case "savings_record":
        lable = "SAVINGS RECORD";
        backgroundColor = orangeLableColor;
        break;
      case "wallet_savings":
        lable = "WALLET SAVINGS";
        backgroundColor = greenLableColor;
        break;
      default:
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.7),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          defaultShadow,
        ],
      ),
      child: Text(
        lable,
        style: labelSmallTextStyle.copyWith(
          color: whiteColor,
          fontWeight: semibold,
        ),
      ),
    );
  }
}
