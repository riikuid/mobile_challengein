// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/history_model.dart';

import 'package:mobile_challengein/theme.dart';

class SavingHistoryTile extends StatelessWidget {
  final HistoryModel? history;
  const SavingHistoryTile({
    Key? key,
    this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTopUp = true;

    String iconPath = "assets/icon_";

    if (history == "Withdraw") {
      isTopUp = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isTopUp ? Icons.add_card : Icons.outbox,
                color: primaryColor500,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTopUp ? "Top Up" : "Withdraw",
                    style: labelLargeTextStyle.copyWith(
                      color: blackColor,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Today",
                    style: labelNormalTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+Rp150,000",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelLargeTextStyle.copyWith(
                    color: blackColor,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "Success",
                  style: labelNormalTextStyle.copyWith(
                    color: greenLableColor,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
