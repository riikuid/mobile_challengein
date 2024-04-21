import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/user_model.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/home_saving_card_skeleton.dart';
import 'package:mobile_challengein/widget/home_savings_card.dart';
import 'package:mobile_challengein/widget/home_status_tile.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';
import 'package:mobile_challengein/widget/saving_card_skeleton.dart';
import 'package:mobile_challengein/widget/savings_label.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    UserModel user = authProvider.user;

    SavingProvider savingProvider = Provider.of<SavingProvider>(context);

    Future<void> getAllSavings() async {
      await savingProvider.getSavings(user.refreshToken);
    }

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
                            "Hai, ${user.name.split(" ").first}",
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: Icon(
                            isObscure
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            size: 16,
                            color: subtitleTextColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      isObscure ? "Rp---" : "Rp50,000",
                      style: headingLargeTextStyle.copyWith(
                        fontWeight: semibold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: HomeStatusTile(
                            icon: "assets/icon/icon_wallet_savings.svg",
                            lable: "Wallet Savings",
                            value: isObscure ? "Rp---" : "Rp50,000",
                          ),
                        ),
                        Expanded(
                          child: HomeStatusTile(
                            icon: "assets/icon/icon_savings_record.svg",
                            lable: "Savings Record",
                            value: isObscure ? "Rp---" : "Rp50,000",
                          ),
                        ),
                        const Expanded(
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
            SizedBox(
              height: 225,
              child: FutureBuilder(
                  future: savingProvider.getSavings(user.refreshToken),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          HomeSavingCardSkeleton(),
                          HomeSavingCardSkeleton(),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'Failed to load savings',
                            style: primaryTextStyle.copyWith(
                              color: subtitleTextColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Consumer<SavingProvider>(
                          builder: (context, savingProvider, _) {
                        if (savingProvider.savings.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                "You Don't Have Any Saving",
                                style: primaryTextStyle.copyWith(
                                  color: subtitleTextColor,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: RefreshIndicator(
                                onRefresh: () {
                                  return Future.delayed(
                                      const Duration(seconds: 1), () {
                                    setState(() {
                                      getAllSavings();
                                    });
                                  });
                                },
                                color: secondaryColor500,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: savingProvider.savings
                                        .map((item) => HomeSavingsCard(
                                              saving: item,
                                            ))
                                        .toList(),
                                    // children: [
                                    //   // HomeSavingsCard(
                                    //   //   savingType: "savings_record",
                                    //   // ),
                                    //   // HomeSavingsCard(
                                    //   //   savingType: "wallet_savings",
                                    //   // ),
                                    //   // HomeSavingsCard(
                                    //   //   savingType: "savings_record",
                                    //   // ),
                                    // ],
                                  ),
                                )),
                          );
                        }
                      });
                    }
                  }),
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
