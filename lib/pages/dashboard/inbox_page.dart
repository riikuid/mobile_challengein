import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/pages/dashboard/history_page.dart';
import 'package:mobile_challengein/pages/inbox/notification_page.dart';
import 'package:mobile_challengein/pages/inbox/withdraw_page.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/notification_tile.dart';
import 'package:mobile_challengein/widget/withdraw_tile.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    TabBar _tabBar = TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
      tabs: [
        Tab(icon: Text("Notification")),
        Tab(icon: Text("Withdraw History")),
      ],
      // labelStyle: styleTabText,
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: whiteColor,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(color: primaryColor500).copyWith(
            fontWeight: semibold,
          ),
          indicatorColor: primaryColor500,
          // labelStyle: primaryTextStyle.copyWith(color: primar),
          tabs: [
            Tab(icon: Text("Notification")),
            Tab(icon: Text("Withdraw History")),
          ],
        ),
        // title: Text(
        //   "History Transaction",
        //   style: headingMediumTextStyle.copyWith(
        //     fontWeight: semibold,
        //   ),
        // ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotificationPage(),
          WithdrawPage(),
          // Scaffold(
          //   backgroundColor: whiteColor,
          //   body: Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: Column(
          //       children: [
          //         WithdrawTile(),
          //         Divider(
          //           height: 30,
          //         ),
          //         WithdrawTile(),
          //         Divider(
          //           height: 30,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
