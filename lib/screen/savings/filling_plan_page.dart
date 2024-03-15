import 'package:flutter/material.dart';
import 'package:mobile_challengein/screen/savings/flexible_filling_plan_page.dart';
import 'package:mobile_challengein/screen/savings/select_date_filling_plan_page.dart';
import 'package:mobile_challengein/theme.dart';

import 'package:toggle_switch/toggle_switch.dart';

class FillingPlanPage extends StatefulWidget {
  final int targetAmount;
  final DateTime? estimatedTarget;
  final String? fillingFreequency;
  final int? fillingPlan;
  final int? fillingNominal;
  const FillingPlanPage({
    super.key,
    required this.targetAmount,
    this.estimatedTarget,
    this.fillingFreequency,
    this.fillingPlan,
    this.fillingNominal,
  });

  @override
  State<FillingPlanPage> createState() => _FillingPlanPageState();
}

class _FillingPlanPageState extends State<FillingPlanPage> {
  PageController _pageController = PageController();
  TextEditingController fillingNominalController =
      TextEditingController(text: "");
  TextEditingController dateController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: primaryColor500,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        title: Text(
          "Set a Filling Plan",
          style: headingNormalTextStyle.copyWith(
            color: whiteColor,
            fontWeight: semibold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Choose the way you want to achieve your goal",
              style: headingNormalTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ToggleSwitch(
              initialLabelIndex: 0,
              totalSwitches: 2,
              minWidth: (screenSize.width - 45) / 2,
              labels: const ['Select Date', 'Flexible'],
              activeBgColor: [secondaryColor50],
              activeFgColor: secondaryColor500,
              activeBorders: [Border.all(color: secondaryColor500)],
              inactiveFgColor: subtitleTextColor,
              inactiveBgColor: whiteColor,
              borderColor: [subtitleTextColor],
              borderWidth: 1,
              cornerRadius: 5,
              onToggle: (index) {
                _pageController.jumpToPage(index!);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  SelectDateFillingPlanPage(
                    targetAmount: widget.targetAmount,
                  ),
                  FlexibleFillingPlanPage(
                    fillingNominalController: fillingNominalController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
