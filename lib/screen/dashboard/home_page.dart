import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/home_savings_card.dart';
import 'package:mobile_challengein/widget/home_status_tile.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return ColoredBox(
        color: primaryColor500,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: whiteColor,
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
                            "Hai, Kamu",
                            style: paragraphNormalTextStyle.copyWith(
                              color: whiteColor,
                              fontWeight: semibold,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Have a nice day",
                            style: paragraphSmallTextStyle.copyWith(
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.notifications,
                    color: whiteColor,
                    size: 25,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Savings Amount",
                          style: labelNormalTextStyle.copyWith(
                            color: subtitleTextColor,
                            fontWeight: semibold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.remove_red_eye,
                          size: 16,
                          color: subtitleTextColor,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Rp50,000",
                      style: headingLargeTextStyle.copyWith(
                        fontWeight: semibold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: HomeStatusTile(
                            icon: "assets/icon/icon_wallet_savings.svg",
                            lable: "Wallet Savings",
                            value: "Rp50,000",
                          ),
                        ),
                        Expanded(
                          child: HomeStatusTile(
                            icon: "assets/icon/icon_savings_record.svg",
                            lable: "Savings Record",
                            value: "Rp50,000",
                          ),
                        ),
                        Expanded(
                          child: HomeStatusTile(
                            icon: "assets/icon/icon_savings_count.svg",
                            lable: "Savings Count",
                            value: "3 Savings",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget mySavings() {
      return ColoredBox(
        color: whiteColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Savings",
                    style: headingSmallTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  ),
                  Text(
                    "SEE ALL",
                    style: labelNormalTextStyle.copyWith(
                      color: primaryColor500,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HomeSavingsCard(),
                  HomeSavingsCard(),
                  HomeSavingsCard(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Widget latesTransaction() {
      return ColoredBox(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Transaction",
                    style: headingSmallTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  ),
                  Text(
                    "SEE ALL",
                    style: labelNormalTextStyle.copyWith(
                      color: primaryColor500,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const MainHistoryTile(),
              const MainHistoryTile(),
              const MainHistoryTile(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: greyBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(),
            mySavings(),
            const SizedBox(
              height: 10,
            ),
            latesTransaction(),
          ],
        ),
      ),
    );
  }
}
