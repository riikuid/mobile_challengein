import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/model/topup_model.dart';
import 'package:mobile_challengein/pages/dashboard/history_page.dart';
import 'package:mobile_challengein/pages/dashboard/home_page.dart';
import 'package:mobile_challengein/pages/dashboard/inbox_page.dart';
import 'package:mobile_challengein/pages/dashboard/savings_page.dart';

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 0;

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
      SvgPicture.asset("assets/icon/icon_mail.svg"),
      SvgPicture.asset("assets/icon/icon_mail_fill.svg"),
      const InboxPage(),
    ],
  ];

  int get currentIndex => _currentIndex;

  List<Widget> get pages =>
      dashboardMenu.map((item) => item[2] as Widget).toList();

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  TopUpModel? _topUpModel;
  TopUpModel? get topUpModel => _topUpModel;

  bool isOnTopUp = false;

  void setTopUpModel({required TopUpModel data}) {
    _topUpModel = data;
    isOnTopUp = true;
    notifyListeners();
    // Duration countdownDuration = data.qrExpired!.difference(DateTime.now());
    // Future.delayed(
    //   countdownDuration,
    //   () {},
    // );
  }

  void clearTopUpModel() {
    isOnTopUp = false;
    _topUpModel = null;
    notifyListeners();
  }
}
