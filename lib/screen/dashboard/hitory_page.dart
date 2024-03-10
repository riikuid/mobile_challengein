import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/search_filter_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "History Transaction",
          style: headingLargeTextStyle.copyWith(
            fontWeight: semibold,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            SearchFilterWidget(),
          ],
        ),
      ),
    );
  }
}
