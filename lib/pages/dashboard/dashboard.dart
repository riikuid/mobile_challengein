import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/pages/dashboard/bottombar.dart';
import 'package:mobile_challengein/pages/savings/top_up_page.dart';
import 'package:mobile_challengein/provider/dashboard_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/countdown_widget.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData device = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(content: Text("Press back again to leave")),
        child: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, child) {
            return dashboardProvider.pages[dashboardProvider.currentIndex];
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: Consumer<SavingProvider>(
        builder: (context, savingProvider, child) {
          print("TOP UP MODEL: ${savingProvider.topUpModel.toString()}");
          if (savingProvider.topUpModel != null) {
            return SizedBox(
              width: device.size.width - 30,
              height: 50,
              child: FloatingActionButton(
                backgroundColor: secondaryColor600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TopUpPage(topUpModel: savingProvider.topUpModel!),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 6,
                  ),
                  child: Align(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TOP UP - ${savingProvider.topUpModel!.savings!.goalName}",
                                style: primaryTextStyle.copyWith(
                                  color: whiteColor,
                                  fontWeight: bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Expired at ${AppHelper.formatDateTimeWithWIB(savingProvider.topUpModel!.qrExpired!)}",
                                style: primaryTextStyle.copyWith(
                                  color: whiteColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          AppHelper.formatCurrency(
                              savingProvider.topUpModel!.topupAmount!),
                          style: primaryTextStyle.copyWith(
                            color: whiteColor,
                            fontWeight: bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
