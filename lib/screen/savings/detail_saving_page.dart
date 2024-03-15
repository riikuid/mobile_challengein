// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challengein/widget/custom_switch.dart';
import 'package:mobile_challengein/widget/saving_hitory_tile.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/frequency_dropdown.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/savings_label.dart';
import 'package:mobile_challengein/widget/set_reminder_widget.dart';

class DetailSavingPage extends StatefulWidget {
  final String savingType;
  const DetailSavingPage({
    super.key,
    required this.savingType,
  });

  @override
  State<DetailSavingPage> createState() => _DetailSavingPageState();
}

class _DetailSavingPageState extends State<DetailSavingPage> {
  bool switchValue = false;

  late ScrollController _scrollController;
  bool lastStatus = true;
  double height = 390;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Widget fillingPlanRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: paragraphSmallTextStyle.copyWith(
                color: subtitleTextColor,
              ),
            ),
            Text(
              value,
              style: paragraphSmallTextStyle,
            ),
          ],
        ),
      );
    }

    Widget balanceAndAction() {
      return ColoredBox(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Balance",
                style: labelLargeTextStyle.copyWith(
                  color: subtitleTextColor,
                ),
              ),
              Text(
                "Rp20,000,000,000",
                style: headingLargeTextStyle.copyWith(
                  color: blackColor,
                  fontWeight: semibold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified,
                    color: subtitleTextColor,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Rp1,000,000,000",
                    style: paragraphNormalTextStyle.copyWith(
                      color: subtitleTextColor,
                      fontWeight: medium,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: whiteColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Top Up",
                            style: headingSmallTextStyle.copyWith(
                              color: whiteColor,
                              fontWeight: semibold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/icon/icon_withdraw.svg"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Withdraw",
                            style: headingSmallTextStyle.copyWith(
                              color: whiteColor,
                              fontWeight: semibold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget fillingPlanAndReminder() {
      return ColoredBox(
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fillingPlanRow("Target Date", "19 January 2025"),
              fillingPlanRow("Filling Plan", "40,000 Per Week"),
              fillingPlanRow("Estimation", "700 More Fills"),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: primaryColor50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.alarm,
                        color: primaryColor500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "12:00",
                          style: paragraphLargeTextStyle.copyWith(
                            fontWeight: semibold,
                          ),
                        ),
                        Text(
                          "Sunday, Monday, Tuesday, Wednesday",
                          style: paragraphSmallTextStyle.copyWith(
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomSwitch(
                    value: switchValue,
                    enableColor: primaryColor500,
                    disableColor: disabledColor,
                    onChanged: (value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: greyBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: transparentColor,
        backgroundColor: transparentColor,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_horiz_outlined,
              size: 30,
            ),
            color: whiteColor,
            surfaceTintColor: whiteColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_note_outlined,
                        size: 16,
                        color: blackColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Edit"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 16,
                        color: secondaryColor600,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Delete",
                        style: labelNormalTextStyle.copyWith(
                          color: secondaryColor600,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {},
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 30, top: 60),
              width: screenSize.width,
              // height: screenSize.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    "assets/image/example_savings.png",
                  ),
                  colorFilter: ColorFilter.mode(
                      blackColor.withOpacity(0.5), BlendMode.multiply),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.2,
                            cornerStyle: CornerStyle.bothCurve,
                            color: whiteColor.withOpacity(0.3),
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              color: primaryColor400,
                              value: 20,
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.2,
                              sizeUnit: GaugeSizeUnit.factor,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              positionFactor: 0.1,
                              angle: 90,
                              widget: Text(
                                '20%',
                                style: headingExtraLargeTextStyle.copyWith(
                                  fontSize: 40,
                                  fontWeight: semibold,
                                  color: whiteColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "IPHONE 14 PRO MAX",
                      textAlign: TextAlign.center,
                      style: headingLargeTextStyle.copyWith(
                        color: whiteColor,
                        fontWeight: semibold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SavingsTypeLable(savingsType: widget.savingType),
                ],
              ),
            ),
            balanceAndAction(),
            const SizedBox(
              height: 10,
            ),
            fillingPlanAndReminder(),
            const SizedBox(
              height: 10,
            ),
            ColoredBox(
              color: whiteColor,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    SavingHistoryTile(
                      type: "Withdraw",
                    ),
                    SavingHistoryTile(),
                    SavingHistoryTile(),
                    SavingHistoryTile(
                      type: "Withdraw",
                    ),
                    SavingHistoryTile(),
                    SavingHistoryTile(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
