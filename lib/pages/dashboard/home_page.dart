import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/model/user_model.dart';
import 'package:mobile_challengein/pages/auth/sign_in_page.dart';
import 'package:mobile_challengein/pages/savings/create_saving_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/dashboard_provider.dart';
import 'package:mobile_challengein/provider/history_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/home_saving_card_skeleton.dart';
import 'package:mobile_challengein/widget/home_savings_card.dart';
import 'package:mobile_challengein/widget/home_user_savings_widget.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';
import 'package:mobile_challengein/widget/main_history_tile_skeleton.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/saving_type_card.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String errorGetSavingText = "Error to Get Saving";
  String errorGetHistory = "No History Found";
  String errorToFetchUserSaving = "Error to Fetch User Saving";
  String errorLogout = "Failed to Logout";
  bool isObscure = true;

  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late UserModel user = authProvider.user;
  late SavingProvider savingProvider =
      Provider.of<SavingProvider>(context, listen: false);
  late HistoryProvider historyProvider =
      Provider.of<HistoryProvider>(context, listen: false);
  late Future<void> futureGetSavings;
  late Future<void> futureGetHistories;

  Future<void> getAllSavings() async {
    await savingProvider.getSavings(
      user.refreshToken,
      (p0) => setState(() {
        errorGetSavingText = p0;
      }),
      "",
    );
  }

  Future<void> handleLogout() async {
    bool logoutStatus = await authProvider.logout(
      user: user,
      errorCallback: (p0) => setState(() {
        errorLogout = p0.toString();
      }),
    );
    Navigator.pop(context);
    if (logoutStatus) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ));
      ThrowSnackbar().showError(context, "Successfully Logged Out");
    } else {
      ThrowSnackbar().showError(context, errorLogout);
    }
  }

  Future<void> getRecentHistory() async {
    await historyProvider.refreshGetHistory(
      statusTrx: "",
      typeTrx: "",
      startDate: "",
      endDate: "",
    );
  }

  void _showSavingsTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'CHOOSE YOUR SAVING TYPE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Determine the type of savings you will make for your goals',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateSavingPage(
                        savingType: SavingType.wallet,
                      ),
                    ),
                  ),
                  child: SavingsTypeCard(
                    color: greenLableColor,
                    title: 'WALLET SAVINGS',
                    description:
                        'Savings that you can top up using real money by payment gateway',
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateSavingPage(
                        savingType: SavingType.record,
                      ),
                    ),
                  ),
                  child: SavingsTypeCard(
                    color: orangeLableColor,
                    title: 'SAVINGS RECORD',
                    description:
                        'A savings recorder that can be used for savings managers without top up with real money',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    futureGetSavings = getAllSavings();
    futureGetHistories = getRecentHistory();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return ColoredBox(
        color: primaryColor500,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            40,
            20,
            20,
          ),
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
                  IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!

                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: whiteColor,
                              insetPadding: EdgeInsets.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 40),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              content: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          secondaryColor500.withOpacity(0.3),
                                      child: Icon(
                                        Icons.logout,
                                        size: 20,
                                        color: secondaryColor600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Confirm Logout",
                                      style: headingMediumTextStyle.copyWith(
                                        fontWeight: semibold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Do you really want to log out\nof your account?",
                                      textAlign: TextAlign.center,
                                      style: paragraphLargeTextStyle.copyWith(
                                        fontSize: 12,
                                        color: subtitleTextColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: PrimaryButton(
                                            elevation: 0,
                                            color: whiteColor,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: paragraphNormalTextStyle
                                                  .copyWith(
                                                color: blackColor,
                                                fontWeight: regular,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: PrimaryButton(
                                            elevation: 0,
                                            color: secondaryColor500,
                                            onPressed: handleLogout,
                                            child: Text(
                                              "Confirm",
                                              style: paragraphNormalTextStyle
                                                  .copyWith(
                                                color: whiteColor,
                                                fontWeight: regular,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: whiteColor,
                        size: 25,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<SavingProvider>(
                builder: (context, savingProvider, _) {
                  if (savingProvider.userSaving == null) {
                    return const HomeUserSavingsWidget();
                  } else {
                    return HomeUserSavingsWidget(
                      userSaving: savingProvider.userSaving!,
                    );
                  }
                },
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
                  GestureDetector(
                    onTap: () {
                      context.read<DashboardProvider>().setIndex(1);
                      // Kembali ke Dashboard dengan menghapus semua rute sebelumnya
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Dashboard()),
                      //   (Route<dynamic> route) => false,
                      // );
                    },
                    child: Text(
                      "SEE ALL",
                      style: labelNormalTextStyle.copyWith(
                        color: primaryColor500,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 225,
              width: MediaQuery.of(context).size.width,
              // width: double.infinity,
              child: FutureBuilder(
                  future: futureGetSavings,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            HomeSavingCardSkeleton(),
                            HomeSavingCardSkeleton(),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          errorGetSavingText,
                          style: primaryTextStyle.copyWith(
                            color: subtitleTextColor,
                          ),
                        ),
                      );
                    } else {
                      return Consumer<SavingProvider>(
                        builder: (context, savingProvider, _) {
                          if (savingProvider.savings.isEmpty) {
                            return Center(
                              child: PrimaryButton(
                                onPressed: () {
                                  _showSavingsTypeDialog(context);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const CreateSavingPage(
                                  //       savingType: "savings_record",
                                  //     ),
                                  //   ),
                                  // );
                                },
                                width: 120,
                                height: 30,
                                child: Text(
                                  "Add New Saving",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10,
                                    fontWeight: semibold,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                              // child: Text(
                              //   errorGetSavingText,
                              //   style: primaryTextStyle.copyWith(
                              //     color: subtitleTextColor,
                              //   ),
                              // ),
                            );
                          } else {
                            return RefreshIndicator(
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
                                        .take(5)
                                        .toList(),
                                  ),
                                ));
                          }
                        },
                      );
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
                  GestureDetector(
                    onTap: () {
                      context.read<DashboardProvider>().setIndex(2);
                    },
                    child: Text(
                      "SEE ALL",
                      style: labelNormalTextStyle.copyWith(
                        color: primaryColor500,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: futureGetHistories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            MainHistoryTileSkeleton(),
                            MainHistoryTileSkeleton(),
                            MainHistoryTileSkeleton(),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          errorGetHistory,
                          style: primaryTextStyle.copyWith(
                            color: subtitleTextColor,
                          ),
                        ),
                      );
                    } else {
                      return Consumer<HistoryProvider>(
                          builder: (context, savingProvider, _) {
                        if (savingProvider.histories.isEmpty) {
                          return Center(
                            child: Text(
                              errorGetHistory,
                              style: primaryTextStyle.copyWith(
                                color: subtitleTextColor,
                              ),
                            ),
                          );
                        } else {
                          return RefreshIndicator(
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
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: historyProvider.histories
                                      .map((item) => MainHistoryTile(
                                            history: item,
                                          ))
                                      .take(5)
                                      .toList(),
                                ),
                              ));
                        }
                      });
                    }
                  }),
              // const MainHistoryTile(),
              // const MainHistoryTile(),
              // const MainHistoryTile(),
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
