import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';
import 'package:mobile_challengein/widget/search_filter_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget listHistory() {
      return Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: const [
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
            MainHistoryTile(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        surfaceTintColor: transparentColor,
        backgroundColor: whiteColor,
        title: Text(
          "History Transaction",
          style: headingMediumTextStyle.copyWith(
            fontWeight: semibold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            const SearchFilterWidget(),
            const SizedBox(
              height: 10,
            ),
            listHistory()
          ],
        ),
      ),
    );
  }
}
