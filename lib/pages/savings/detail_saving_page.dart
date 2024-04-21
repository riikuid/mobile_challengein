import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/format_currency.dart';
import 'package:mobile_challengein/common/format_date.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/widget/custom_switch.dart';
import 'package:mobile_challengein/widget/saving_hitory_tile.dart';
import 'package:mobile_challengein/widget/savings_record_modal.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/savings_label.dart';

class DetailSavingPage extends StatefulWidget {
  final SavingModel saving;
  const DetailSavingPage({
    super.key,
    required this.saving,
  });

  @override
  State<DetailSavingPage> createState() => _DetailSavingPageState();
}

class _DetailSavingPageState extends State<DetailSavingPage> {
  TextEditingController modalController = TextEditingController(text: "");
  FocusNode modalFocus = FocusNode();
  late ScrollController _scrollController;
  bool switchValue = false;
  bool lastStatus = true;
  double height = 330;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    switchValue = widget.saving.isReminder;
    super.initState();
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
        // print(_isShrink);
      });
    }
  }

  String fillingPlanFormating() {
    String result = "${formatCurrency(widget.saving.fillingNominal)} Per ";
    String freequency = "";
    switch (widget.saving.fillingFrequency) {
      case "daily":
        freequency = "Day";
        break;
      case "weekly":
        freequency = "Week";
        break;
      case "monthly":
        freequency = "Month";
        break;
      default:
    }
    return result + freequency;
  }

  void _showModalBottomSheet(
      BuildContext context, SavingsRecordModalType modalType) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SavingsRecordModal(
          modalType: modalType,
        );
      },
    );
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Widget fillingPlanRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: subtitleTextColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: paragraphSmallTextStyle.copyWith(
                    color: subtitleTextColor,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: paragraphSmallTextStyle,
            ),
          ],
        ),
      );
    }

    Widget appbarBackground() {
      return Container(
        padding: const EdgeInsets.only(bottom: 30, top: 60),
        width: screenSize.width,
        // height: screenSize.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.saving.pathImage,
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
                        value: widget.saving.progressSavings.toDouble(),
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
                          '${widget.saving.progressSavings}%',
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
                widget.saving.goalName,
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
            SavingsTypeLable(savingsType: widget.saving.savingType),
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
                formatCurrency(widget.saving.savingAmount),
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
                    Icons.savings,
                    color: subtitleTextColor,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    formatCurrency(widget.saving.targetAmount),
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
                      onPressed: () {
                        _showModalBottomSheet(
                            context, SavingsRecordModalType.increase);
                      },
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
                            "Increase",
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
                      onPressed: () {
                        _showModalBottomSheet(
                            context, SavingsRecordModalType.decrease);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: whiteColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Decrease",
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
              fillingPlanRow(
                Icons.date_range,
                "Target Date",
                formatDateToString(widget.saving.targetDate),
              ),
              fillingPlanRow(
                Icons.currency_exchange,
                "Filling Plan",
                fillingPlanFormating(),
              ),
              fillingPlanRow(
                Icons.price_change_outlined,
                "Estimation",
                "${widget.saving.fillingEstimation} More Fills",
              ),
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
                          widget.saving.dayReminder.join(", "),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 1,
            leading: BackButton(
              color: whiteColor,
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz_outlined,
                  color: whiteColor,
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
            // leading: _isShrink ? const BackButton() : null,
            pinned: true,
            floating: true,
            backgroundColor: primaryColor500,
            expandedHeight: height,
            flexibleSpace: FlexibleSpaceBar(
              title: innerBoxIsScrolled
                  ? Text(
                      'IPHONE 14 PRO MAX',
                      style: headingNormalTextStyle.copyWith(
                        color: whiteColor,
                        fontWeight: semibold,
                      ),
                    )
                  : const SizedBox(),
              background: appbarBackground(),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                      SavingHistoryTile(),
                      SavingHistoryTile(),
                      SavingHistoryTile(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
