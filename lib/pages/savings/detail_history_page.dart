import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/history_model.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/savings_label.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryModel history;
  const DetailHistoryPage({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    Widget categoryLable({
      required String iconPath,
      required Color iconColor,
      required String lable,
    }) {
      return Row(
        children: [
          SvgPicture.asset(
            iconPath,
            color: iconColor,
            height: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            lable,
            style: primaryTextStyle.copyWith(
              color: blackColor,
              fontSize: 12,
              fontWeight: regular,
            ),
          ),
        ],
      );
    }

    Widget getCategoryLable(String typeTransaction) {
      typeTransaction =
          typeTransaction.toUpperCase(); // Case-insensitive comparison

      switch (typeTransaction) {
        case 'DECREASE':
          return categoryLable(
              iconPath: "assets/icon/icon_withdraw.svg",
              lable: "Decrease",
              iconColor: redLableColor);
        case 'INCREASE':
          return categoryLable(
              iconPath: "assets/icon/icon_withdraw.svg",
              lable: "Increase",
              iconColor: greenLableColor.withOpacity(0.5));
        case 'TOP UP':
          return categoryLable(
              iconPath: "assets/icon/icon_topup.svg",
              lable: "Top Up",
              iconColor: greenLableColor.withOpacity(0.5));
        case 'WITHDRAW':
          return categoryLable(
              iconPath: "assets/icon/icon_withdraw.svg",
              lable: "Withdraw",
              iconColor: redLableColor);
        default:
          return categoryLable(
              iconPath: "assets/icon/icon_withdraw.svg",
              lable: "-",
              iconColor: orangeLableColor);
      }
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "Detail Transction",
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semibold,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(
                  history.typeTrx == "Decrease" || history.typeTrx == "Withdraw"
                      ? "assets/icon/icon_history_up.svg"
                      : "assets/icon/icon_history_down.svg",
                  height: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      history.goalName,
                      style: primaryTextStyle.copyWith(
                        fontWeight: regular,
                        color: subtitleTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      ((history.typeTrx == "Decrease" ||
                                  history.typeTrx == "Withdraw")
                              ? "-"
                              : "+") +
                          AppHelper.formatCurrency(history.amountMoney),
                      style: primaryTextStyle.copyWith(
                        fontWeight: semibold,
                        color: blackColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transaction ID",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppHelper.truncateWdId(
                            history.id,
                          ),
                          style: primaryTextStyle.copyWith(
                            color: blackColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        SizedBox(
                          height: 14,
                          width: 14,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            splashRadius: 2,
                            iconSize: 12,
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: history.id));
                              Fluttertoast.showToast(
                                  msg: "Transaction id copied to clipboard!");
                            },
                            icon: Icon(
                              Icons.copy,
                              color: secondaryColor500,
                              weight: 5,
                              // fill: 4,
                            ),
                          ),
                        ),
                      ],
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
                      history.statusTrx,
                      style: primaryTextStyle.copyWith(
                        color:
                            AppHelper.getColorBasedOnStatus(history.statusTrx),
                        fontSize: 12,
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
                      AppHelper.formatDateToString(history.updatedAt),
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
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
                      AppHelper.formatDateTimeToWIB(history.updatedAt),
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
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
                      "Category",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    getCategoryLable(history.typeTrx)
                  ],
                ),
              ],
            ),
            // const Expanded(
            //   child: SizedBox(),
            // ),
            // PrimaryButton(
            //   child: Text(
            //     "Back To Home",
            //     style: primaryTextStyle.copyWith(
            //       color: whiteColor,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => Dashboard(),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }
}
