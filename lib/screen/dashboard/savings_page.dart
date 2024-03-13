import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_challengein/screen/savings/create_saving_page.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/savings_card.dart';
import 'package:mobile_challengein/widget/search_filter_widget.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        surfaceTintColor: transparentColor,
        backgroundColor: whiteColor,
        actions: [
          SizedBox(
            height: 32,
            width: 120,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateSavingPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                backgroundColor: primaryColor500,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                elevation: 0,
                // fixedSize: Size(150, 20),
              ),
              child: Text(
                "Create Goal",
                style: labelNormalTextStyle.copyWith(
                  color: whiteColor,
                  fontWeight: semibold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        title: Text(
          "Savings",
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
            Expanded(
              child: ListView(
                children: const [
                  SavingsCard(),
                  SavingsCard(),
                  SavingsCard(),
                  SavingsCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
