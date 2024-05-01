// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/format_currency.dart';
import 'package:mobile_challengein/common/format_date.dart';

import 'package:mobile_challengein/model/history_model.dart';
import 'package:mobile_challengein/theme.dart';

class MainHistoryTile extends StatelessWidget {
  final HistoryModel history;
  const MainHistoryTile({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      history.pathImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                  color: subtitleTextColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.typeTrx,
                    style: labelLargeTextStyle.copyWith(
                      color: blackColor,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    formatDateToString(history.updatedAt),
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
                  formatCurrency(history.amountMoney),
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
                  history.statusTrx,
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
