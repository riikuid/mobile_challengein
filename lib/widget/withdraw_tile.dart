import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/payout_model.dart';
import 'package:mobile_challengein/theme.dart';

class WithdrawTile extends StatelessWidget {
  final PayoutModel payout;
  const WithdrawTile({super.key, required this.payout});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppHelper.formatDateTimeWithWIB(payout.updatedAt),
          style: primaryTextStyle.copyWith(
            color: subtitleTextColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${payout.bankName} - ${payout.nameRekening}",
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    payout.statusPayouts,
                    style: primaryTextStyle.copyWith(
                      color: AppHelper.getColorBasedOnStatusWD(
                        payout.statusPayouts,
                      ),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "-${AppHelper.formatCurrency(payout.amountMoney)}",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semibold,
                color: primaryColor600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
