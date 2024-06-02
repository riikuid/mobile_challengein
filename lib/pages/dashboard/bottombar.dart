import 'package:flutter/material.dart';
import 'package:mobile_challengein/provider/dashboard_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dashboardProvider = Provider.of<DashboardProvider>(context);

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
        selectedIndex: dashboardProvider.currentIndex,
        onDestinationSelected: (value) {
          dashboardProvider.setIndex(value);
        },
        destinations: dashboardProvider.dashboardMenu.map(
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
}
