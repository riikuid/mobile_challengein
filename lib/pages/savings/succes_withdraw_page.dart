import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/payout_model.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessWithdrawPage extends StatelessWidget {
  final PayoutModel payoutModel;
  const SuccessWithdrawPage({super.key, required this.payoutModel});

  @override
  Widget build(BuildContext context) {
    bool isMoreThan48Hours(DateTime inputDateTime) {
      // Ambil waktu sekarang
      DateTime now = DateTime.now();

      // Hitung selisih waktu antara waktu sekarang dan waktu input
      Duration difference = now.difference(inputDateTime);

      // Periksa apakah selisih waktu lebih dari atau sama dengan 48 jam
      return difference.inHours >= 48;
    }

    String _getSubtitleText() {
      String payout = payoutModel.statusPayouts.toUpperCase();
      switch (payout) {
        case "SUCCESS":
          return "successful";
        case "PROCESS":
          return "processed";
        case "FAILED":
          return "failed";
        default:
          return "processed";
      }
    }

    Widget _getIconStatus() {
      String payout = payoutModel.statusPayouts.toUpperCase();

      switch (payout) {
        case "SUCCESS":
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: greenLableColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(1000),
              ),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: greenLableColor,
              size: 80,
            ),
          );
        case "PROCESS":
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: orangeLableColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(1000),
              ),
            ),
            child: Icon(
              Icons.hourglass_top,
              color: orangeLableColor,
              size: 80,
            ),
          );

        case "FAILED":
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: redLableColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(1000),
              ),
            ),
            child: Icon(
              Icons.priority_high,
              color: redLableColor,
              size: 80,
            ),
          );

        default:
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: greenLableColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(1000),
              ),
            ),
            child: Icon(
              Icons.check_circle_outline_sharp,
              color: greenLableColor,
              size: 80,
            ),
          );
      }
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        surfaceTintColor: transparentColor,
        backgroundColor: whiteColor,
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
            const SizedBox(
              height: 10,
            ),
            _getIconStatus(),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Request Accepted!",
              style: primaryTextStyle.copyWith(
                color: AppHelper.getColorBasedOnStatusWD(
                    payoutModel.statusPayouts),
                fontSize: 20,
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Your withdrawal request\nis ${_getSubtitleText()}.",
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
                    Row(
                      children: [
                        Text(
                          AppHelper.truncateWdId(
                            payoutModel.id,
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
                                  ClipboardData(text: payoutModel.id));
                              Fluttertoast.showToast(
                                  msg: "Withdraw id copied to clipboard!");
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
                    // Text(
                    //   AppHelper.truncateWdId(
                    //     payoutModel.id,
                    //   ),
                    //   style: primaryTextStyle.copyWith(
                    //     color: blackColor,
                    //     fontSize: 12,
                    //     // fontWeight: semibold,
                    //   ),
                    // )
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
                        color: payoutModel.statusPayouts == "Process"
                            ? orangeLableColor
                            : payoutModel.statusPayouts == "Success"
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
                        // fontWeight: semibold,
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
                        // fontWeight: semibold,
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
                        // fontWeight: semibold,
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
                      payoutModel.bankName,
                      style: primaryTextStyle.copyWith(
                        color: blackColor,
                        fontSize: 12,
                        // fontWeight: semibold,
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
                      "Account Name",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        payoutModel.nameRekening,
                        style: primaryTextStyle.copyWith(
                          color: blackColor,
                          fontSize: 12,
                          // fontWeight: semibold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
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
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        payoutModel.norek,
                        style: primaryTextStyle.copyWith(
                          color: blackColor,
                          fontSize: 12,
                          // fontWeight: semibold,
                        ),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            isMoreThan48Hours(payoutModel.createdAt)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have problem with this transaction? ",
                        style: primaryTextStyle.copyWith(
                          fontSize: 12,
                          color: subtitleTextColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final Uri params = Uri(
                            scheme: 'mailto',
                            path: 'support@example.com',
                            query:
                                'subject=Transaction Issue', // Add your email subject and other parameters here
                          );
                          var url = params.toString();
                          if (await canLaunchUrl(params)) {
                            await launch(url);
                          } else {
                            // You can handle the error here
                            print('Could not launch $url');
                          }
                        },
                        child: Text("Contact Us",
                            style: primaryTextStyle.copyWith(
                              color: primaryColor600,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  )
                : payoutModel.statusPayouts.toUpperCase == "SUCCESS"
                    ? Text(
                        "Your transaction is being processed.\nPlease allow up to 2x24 hours.",
                        style: primaryTextStyle.copyWith(
                          fontSize: 12,
                          color: subtitleTextColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have problem with this transaction? ",
                            style: primaryTextStyle.copyWith(
                              fontSize: 12,
                              color: subtitleTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              String? encodeQueryParameters(
                                  Map<String, String> params) {
                                return params.entries
                                    .map((MapEntry<String, String> e) =>
                                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                    .join('&');
                              }

                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'vikisahputra17@gmail.com',
                                query: encodeQueryParameters(<String, String>{
                                  'subject':
                                      'Have issue with transcation #${payoutModel.id}',
                                }),
                              );
                              // final Uri params = Uri(
                              //   scheme: 'mailto',
                              //   path: 'vikisahputra17@gmail.com',
                              //   query:
                              //       'subject=Transaction Issue', // Add your email subject and other parameters here
                              // );
                              // var url = params.toString();
                              if (await launchUrl(emailLaunchUri)) {
                                // await launch(url);
                              } else {
                                // You can handle the error here
                                Fluttertoast.showToast(msg: "Can't open mail");
                                // print('Could not launch $url');
                              }
                            },
                            child: Text("Contact Us",
                                style: primaryTextStyle.copyWith(
                                  color: primaryColor600,
                                  fontSize: 12,
                                )),
                          ),
                        ],
                      ),

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
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
