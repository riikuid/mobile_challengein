import 'package:flutter/material.dart';
import 'package:mobile_challengein/pages/savings/detail_saving_page.dart';
import 'package:mobile_challengein/pages/savings/succes_withdraw_page.dart';
import 'package:mobile_challengein/provider/inbox_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/notification_tile.dart';
import 'package:mobile_challengein/widget/saving_card_skeleton.dart';
import 'package:mobile_challengein/widget/withdraw_tile.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  late InboxProvider inboxProvider =
      Provider.of<InboxProvider>(context, listen: false);
  String errorGetWithdrawHistories = "Withdraw not found";
  late Future<void> futureGetPayoutHistory;

  Future<bool> getAllPayoutHistory() async {
    bool result = await inboxProvider.getPayoutHistory(
      (p0) => setState(() {
        errorGetWithdrawHistories = p0;
      }),
    );
    return result;
  }

  @override
  void initState() {
    super.initState();
    futureGetPayoutHistory = getAllPayoutHistory();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            FutureBuilder(
              future: futureGetPayoutHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.separated(
                        itemCount: 10,
                        separatorBuilder: (context, index) => Divider(
                          height: 30,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 14,
                                width: screenWidth / 2.5,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: blackColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 12,
                                        width: screenWidth / 2,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: blackColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 14,
                                        width: screenWidth / 3,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: blackColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                    width: screenWidth / 3.5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: blackColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        errorGetWithdrawHistories,
                        style: primaryTextStyle.copyWith(
                          color: subtitleTextColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Consumer<InboxProvider>(
                      builder: (context, inboxProvider, _) {
                    if (inboxProvider.payoutHistory.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            errorGetWithdrawHistories,
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
                            return Future.delayed(const Duration(seconds: 1),
                                () {
                              setState(() {
                                getAllPayoutHistory();
                              });
                            });
                          },
                          color: secondaryColor500,
                          child: ListView.separated(
                            itemCount: inboxProvider.payoutHistory.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 30,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      final payoutHistory =
                                          inboxProvider.payoutHistory;

                                      return SuccessWithdrawPage(
                                        payoutModel: payoutHistory[index],
                                      );
                                    },
                                  ));
                                },
                                // child: NotificationTile(
                                //   notificationModel: inboxProvider
                                //       .payoutHistory[index],
                                // ),
                                child: WithdrawTile(
                                  payout: inboxProvider.payoutHistory[index],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
