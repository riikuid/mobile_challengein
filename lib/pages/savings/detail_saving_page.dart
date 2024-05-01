import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/format_currency.dart';
import 'package:mobile_challengein/common/format_date.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/widget/custom_switch.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';
import 'package:mobile_challengein/widget/main_history_tile_skeleton.dart';
import 'package:mobile_challengein/widget/saving_hitory_tile.dart';
import 'package:mobile_challengein/widget/savings_record_modal.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';
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
  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late SavingProvider savingProvider =
      Provider.of<SavingProvider>(context, listen: false);
  FocusNode modalFocus = FocusNode();
  late ScrollController _scrollController;
  bool switchValue = false;
  bool lastStatus = true;
  double height = 330;
  String errorText = "Failed to delete saving";
  late Future<void> futureGetHistories;

  Future<void> _onRefresh() async {
    await savingProvider.refreshGetHistory(
      token: authProvider.user.refreshToken,
      idSaving: widget.saving.id,
    );
  }

  Future<void> getRecentHistory() async {
    await savingProvider.refreshGetHistory(
      token: authProvider.user.refreshToken,
      idSaving: widget.saving.id,
    );
  }

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && context.read<SavingProvider>().hasMore) {
      savingProvider.getHistory(
        token: authProvider.user.refreshToken,
        idSaving: widget.saving.id,
      );
    }
  }

  Future<void> handleDeleteSaving() async {
    await savingProvider
        .deleteSaving(
      idSaving: widget.saving.id,
      token: authProvider.user.refreshToken,
      errorCallback: (e) => setState(
        () {
          errorText = e.toString();
        },
      ),
    )
        .then((value) {
      if (value) {
        Navigator.pop(context);
      } else {
        ThrowSnackbar().showError(context, errorText);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    switchValue = widget.saving.isReminder;
    savingProvider.refreshGetHistory(
      token: authProvider.user.refreshToken,
      idSaving: widget.saving.id,
    );
    _scrollController.addListener(onScroll);
    futureGetHistories = _onRefresh();
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
        // print(_isShrink);
      });
    }
  }

  String fillingPlanFormating(int fillingNominal, String frequency) {
    String result = "${formatCurrency(fillingNominal)} Per ";
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

  void _showModalBottomSheet(BuildContext context,
      SavingsRecordModalType modalType, SavingModel selectedSaving) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
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
          saving: selectedSaving,
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

    Widget appbarBackground(SavingModel selectedSaving) {
      return Hero(
        tag: "image_savings",
        child: Container(
          padding: const EdgeInsets.only(bottom: 30, top: 60),
          width: screenSize.width,
          // height: screenSize.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                selectedSaving.pathImage,
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
                          value: selectedSaving.progressSavings * 100,
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
                            '${(selectedSaving.progressSavings * 100).toStringAsFixed(0)}%',
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
        ),
      );
    }

    Widget balanceAndAction({
      required int savingAmount,
      required int targetAmount,
      required SavingModel selectedSaving,
    }) {
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
                formatCurrency(savingAmount),
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
                    formatCurrency(targetAmount),
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
                          context,
                          SavingsRecordModalType.increase,
                          selectedSaving,
                        );
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
                          context,
                          SavingsRecordModalType.decrease,
                          selectedSaving,
                        );
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

    Widget fillingPlanAndReminder({
      required DateTime targetDate,
      required int fillingNominal,
      required String frequency,
      required int fillingEstimation,
      required String timeReminder,
      required List<String> dayReminder,
    }) {
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
                formatDateToString(targetDate),
              ),
              fillingPlanRow(
                Icons.currency_exchange,
                "Filling Plan",
                fillingPlanFormating(fillingNominal, frequency),
              ),
              fillingPlanRow(
                Icons.price_change_outlined,
                "Estimation",
                "$fillingEstimation More Fills",
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
                          timeReminder,
                          style: paragraphLargeTextStyle.copyWith(
                            fontWeight: semibold,
                          ),
                        ),
                        Text(
                          dayReminder.join(", "),
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

    Widget listHistory() {
      return FutureBuilder(
          future: futureGetHistories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    MainHistoryTileSkeleton(),
                    MainHistoryTileSkeleton(),
                    MainHistoryTileSkeleton(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "No history found",
                  style: primaryTextStyle.copyWith(
                    color: subtitleTextColor,
                  ),
                ),
              );
            } else {
              return Consumer<SavingProvider>(
                  builder: (context, savingProvider, _) {
                if (savingProvider.savingHistories.isEmpty) {
                  return Center(
                    child: Text(
                      "No history found",
                      style: primaryTextStyle.copyWith(
                        color: subtitleTextColor,
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: savingProvider.savingHistories
                          .map((item) => MainHistoryTile(
                                history: item,
                              ))
                          .toList(),
                    ),
                  );
                }
              });
            }
          });
    }

    return Consumer<SavingProvider>(
      builder: (context, savingProvider, _) {
        print("Q Q Q Q Q QQQ");
        if (savingProvider.savings.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                "You Don't Have Any Saving",
                style: primaryTextStyle.copyWith(
                  color: subtitleTextColor,
                ),
              ),
            ),
          );
        } else {
          SavingModel? selectedeSaving = savingProvider.savings
              .where((saving) => saving.id == widget.saving.id)
              .firstOrNull;

          if (selectedeSaving != null) {
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
                              onTap: handleDeleteSaving,
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
                              selectedeSaving.goalName,
                              style: headingNormalTextStyle.copyWith(
                                color: whiteColor,
                                fontWeight: semibold,
                              ),
                            )
                          : const SizedBox(),
                      background: appbarBackground(selectedeSaving),
                    ),
                  )
                ],
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      balanceAndAction(
                        savingAmount: selectedeSaving.savingAmount,
                        targetAmount: selectedeSaving.targetAmount,
                        selectedSaving: selectedeSaving,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      fillingPlanAndReminder(
                        targetDate: selectedeSaving.targetDate,
                        fillingEstimation: selectedeSaving.fillingEstimation,
                        fillingNominal: selectedeSaving.fillingNominal,
                        frequency: selectedeSaving.fillingFrequency,
                        dayReminder: selectedeSaving.dayReminder,
                        timeReminder: selectedeSaving.timeReminder,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ColoredBox(
                        color: whiteColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: listHistory(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // print("QQQQQ ${selectedeSaving.savingAmount}");
        }
      },
    );
  }
}
