import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/pages/dashboard/history_page.dart';
import 'package:mobile_challengein/pages/dashboard/home_page.dart';
import 'package:mobile_challengein/pages/dashboard/profile_page.dart';
import 'package:mobile_challengein/pages/dashboard/savings_page.dart';
import 'package:mobile_challengein/theme.dart';

class Dashboard extends StatefulWidget {
  final int? dashboardValue;
  const Dashboard({
    super.key,
    this.dashboardValue = 0,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int currentIndex = widget.dashboardValue!;

  List dashboardMenu = [
    [
      SvgPicture.asset("assets/icon/icon_home.svg"),
      SvgPicture.asset("assets/icon/icon_home_fill.svg"),
      const HomePage(),
    ],
    [
      SvgPicture.asset("assets/icon/icon_savings.svg"),
      SvgPicture.asset("assets/icon/icon_savings_fill.svg"),
      const SavingsPage(),
    ],
    [
      SvgPicture.asset("assets/icon/icon_history.svg"),
      SvgPicture.asset("assets/icon/icon_history_fill.svg"),
      const HistoryPage(),
    ],
    [
      SvgPicture.asset("assets/icon/icon_profile.svg"),
      SvgPicture.asset("assets/icon/icon_profile_fill.svg"),
      const ProfilePage(),
    ],
  ];

  Widget bottomNavBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [defaultShadow],
      ),
      child: NavigationBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 5,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: dashboardMenu.map(
          (item) {
            return NavigationDestination(
              icon: item[0],
              label: " ",
              selectedIcon: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: item[1],
                  ),
                  SizedBox(
                    height: 3,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: primaryColor500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  void initState() {
    currentIndex = widget.dashboardValue ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: dashboardMenu[currentIndex][2],
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
