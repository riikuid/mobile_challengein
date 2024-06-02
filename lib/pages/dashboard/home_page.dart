import 'package:flutter/material.dart';
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
    if (logoutStatus) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ));
    } else {
      ThrowSnackbar().showError(context, errorLogout);
    }
  }

  Future<void> getRecentHistory() async {
    await historyProvider.refreshGetHistory();
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
                      onPressed: handleLogout,
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
