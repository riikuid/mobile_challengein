import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/payout_model.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';

class SuccessWithdrawPage extends StatelessWidget {
  final PayoutModel payoutModel;
  const SuccessWithdrawPage({super.key, required this.payoutModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: greenLableColor,
              size: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Transaction Success!",
              style: primaryTextStyle.copyWith(
                color: greenLableColor,
                fontSize: 20,
                fontWeight: semibold,
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Text(
              "Your withdrawal request is\nbeing processed.",
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                color: subtitleTextColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Withdraw Detail",
                  style: primaryTextStyle.copyWith(
                    color: blackColor,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Withdraw ID",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      AppHelper.truncateWdId(
                        payoutModel.id,
                      ),
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      payoutModel.statusPayouts,
                      style: primaryTextStyle.copyWith(
                        color: payoutModel.statusPayouts == "PENDING"
                            ? orangeLableColor
                            : payoutModel.statusPayouts == "SUCCESS"
                                ? greenLableColor
                                : blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      AppHelper.formatDateToString(payoutModel.createdAt),
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      AppHelper.formatDateTimeToWIB(payoutModel.createdAt),
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  height: 2,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Amount",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      AppHelper.formatCurrency(payoutModel.amountMoney),
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Destination",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      payoutModel.nameRekening,
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account Number",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      payoutModel.norek,
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            PrimaryButton(
              child: Text(
                "Back To Home",
                style: primaryTextStyle.copyWith(
                  color: whiteColor,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
