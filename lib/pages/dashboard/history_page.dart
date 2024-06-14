import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/history_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/main_history_tile.dart';
import 'package:mobile_challengein/widget/main_history_tile_skeleton.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/search_filter_widget.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isFiltered = false;

  String selectedStatusNew = "All";
  String selectedTypeTrxNew = "All";
  DateTime? startDateNew;
  DateTime? endDateNew;

  String selectedStatusOld = "All";
  String selectedTypeTrxOld = "All";
  DateTime? startDateOld;
  DateTime? endDateOld;

  TextEditingController rangeDateTextControllerNew = TextEditingController();
  TextEditingController rangeDateTextControllerOld = TextEditingController();

  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late HistoryProvider historyProvider =
      Provider.of<HistoryProvider>(context, listen: false);
  final ScrollController _scrollController = ScrollController();
  late Future<void> futureGetHistories;
  String errorGetHistory = "No History Found";

  bool _isLoading = false;
  bool _isLoading1 = false;

  void resetValueBottomSheet() {
    setState(() {
      selectedStatusOld = "All";
      selectedTypeTrxOld = "All";
      startDateOld = null;
      endDateOld = null;
      rangeDateTextControllerOld.clear();
    });
  }

  void resetToOldValueBottomSheet() {
    setState(() {
      selectedStatusNew = selectedStatusOld;
      selectedTypeTrxNew = selectedTypeTrxOld;
      startDateNew = startDateOld;
      endDateNew = endDateOld;
      rangeDateTextControllerNew = rangeDateTextControllerOld;
    });
  }

  void setValueBottomSheet() {
    setState(() {
      selectedStatusOld = selectedStatusNew;
      selectedTypeTrxOld = selectedTypeTrxNew;
      startDateOld = startDateNew;
      endDateOld = endDateNew;
      rangeDateTextControllerOld = rangeDateTextControllerNew;
    });
  }

  Future<void> getRecentHistory() async {
    setState(() {
      // _isLoading = true;
    });
    await historyProvider.refreshGetHistory(
      startDate: startDateNew != null
          ? AppHelper.formatDatePostHistory(startDateNew!)
          : "",
      endDate: endDateNew != null
          ? AppHelper.formatDatePostHistory(endDateNew!)
          : "",
      typeTrx: selectedTypeTrxNew,
      statusTrx: selectedStatusNew,
    );
    // setState(() {
    //   // _isLoading = false;
    // });
  }

  void onScroll({
    String? typeTrx,
    String? statusTrx,
  }) {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && context.read<HistoryProvider>().hasMore) {
      context.read<HistoryProvider>().getHistory(
            startDate: startDateNew != null
                ? AppHelper.formatDatePostHistory(startDateNew!)
                : "",
            endDate: endDateNew != null
                ? AppHelper.formatDatePostHistory(endDateNew!)
                : "",
            typeTrx: selectedTypeTrxNew,
            statusTrx: selectedStatusNew,
            errorCallback: (p0) {
              setState(() {
                errorGetHistory = p0;
              });
            },
          );
    }
  }

  @override
  void initState() {
    _scrollController.addListener(onScroll);
    futureGetHistories = getRecentHistory();

    super.initState();
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      barrierDismissible: true,
      builder: (context, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: child,
        );
      },
      initialDateRange: startDateNew != null && endDateNew != null
          ? DateTimeRange(start: startDateNew!, end: endDateNew!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDateNew = picked.start;
        endDateNew = picked.end;
        rangeDateTextControllerNew.text =
            "${AppHelper.formatDateToString(startDateNew!)} - ${AppHelper.formatDateToString(endDateNew!)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    Widget listHistory() {
      return Expanded(
        child: RefreshIndicator(
          color: primaryColor500,
          backgroundColor: whiteColor,
          onRefresh: getRecentHistory,
          child: FutureBuilder(
              future: futureGetHistories,
              builder: (context, snapshot) {
                return Consumer<HistoryProvider>(builder: (context, state, _) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      children: [
                        MainHistoryTileSkeleton(),
                        MainHistoryTileSkeleton(),
                      ],
                    );
                  } else {
                    if (state.histories.isEmpty) {
                      return Center(
                        child: Text(
                          errorGetHistory,
                          style: primaryTextStyle.copyWith(
                            color: subtitleTextColor,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.hasMore
                            ? state.histories.length + 1
                            : state.histories.length,
                        itemBuilder: (context, index) {
                          if (index < state.histories.length) {
                            return MainHistoryTile(
                              history: state.histories[index],
                            );
                          } else {
                            return const Column(
                              children: [
                                MainHistoryTileSkeleton(),
                                MainHistoryTileSkeleton(),
                              ],
                            );
                          }
                        },
                      );
                    }
                  }
                });
              }),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: transparentColor,
        backgroundColor: whiteColor,
        title: Text(
          "History Transaction",
          style: headingMediumTextStyle.copyWith(
            fontWeight: semibold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    isDismissible: true,
                    shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (BuildContext cok) {
                      return StatefulBuilder(
                        builder: (context, setStateSheet) {
                          Widget _buildStatusTrx(
                            String filter,
                          ) {
                            bool isSelected = selectedStatusNew == filter;
                            return GestureDetector(
                              onTap: () {
                                setStateSheet(() {
                                  selectedStatusNew = filter;
                                });
                                log(selectedStatusNew);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor500
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: isSelected
                                          ? primaryColor500
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  filter,
                                  style: primaryTextStyle.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: isSelected ? regular : regular,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }

                          Widget _buildTypeTrx(
                            String filter,
                          ) {
                            bool isSelected = selectedTypeTrxNew == filter;
                            return GestureDetector(
                              onTap: () {
                                setStateSheet(() {
                                  selectedTypeTrxNew = filter;
                                });
                                log(selectedTypeTrxNew);
                              },
                              child: Container(
                                // margin: EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor500
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: isSelected
                                          ? primaryColor500
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  filter,
                                  style: primaryTextStyle.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: isSelected ? regular : regular,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                              right: 20,
                              left: 20,
                              bottom: 10,
                            ),
                            height: deviceSize.height / 2,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Text(
                                        "Transaction Status",
                                        style: primaryTextStyle.copyWith(
                                          fontWeight: semibold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _buildStatusTrx("All"),
                                          _buildStatusTrx("Success"),
                                          _buildStatusTrx("Pending"),
                                          _buildStatusTrx("Failed"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Date",
                                        style: primaryTextStyle.copyWith(
                                          fontWeight: semibold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextField(
                                        labelText: "",
                                        hintText: "Select Date",
                                        keyboardType: TextInputType.name,
                                        controller: rangeDateTextControllerNew,
                                        prefix: const SizedBox(
                                          width: 15,
                                        ),
                                        textFieldType:
                                            CustomTextFieldType.outline,
                                        isPicker: true,
                                        pickerFunction: _showDateRangePicker,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Category",
                                        style: primaryTextStyle.copyWith(
                                          fontWeight: semibold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _buildTypeTrx("All"),
                                          _buildTypeTrx("Top Up"),
                                          _buildTypeTrx("Withdraw"),
                                          _buildTypeTrx("Increase"),
                                          _buildTypeTrx("Decrease"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryButton(
                                        isLoading: _isLoading1,
                                        isEnabled: !_isLoading,
                                        borderColor: primaryColor500,
                                        color: whiteColor,
                                        height: 40,
                                        child: Text(
                                          "RESET",
                                          style: primaryTextStyle.copyWith(
                                            color: primaryColor500,
                                          ),
                                        ),
                                        onPressed: () async {
                                          setStateSheet(() {
                                            _isLoading1 = true;
                                          });
                                          try {
                                            resetValueBottomSheet();
                                            resetToOldValueBottomSheet();
                                            getRecentHistory();
                                            Navigator.pop(context);
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg: "Try again later");
                                          }
                                          setStateSheet(() {
                                            _isLoading1 = false;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: PrimaryButton(
                                        isLoading: _isLoading,
                                        isEnabled: !_isLoading1,
                                        height: 40,
                                        child: Text(
                                          "APPLY",
                                          style: primaryTextStyle.copyWith(
                                            color: whiteColor,
                                          ),
                                        ),
                                        onPressed: () async {
                                          setStateSheet(() {
                                            _isLoading = true;
                                          });
                                          try {
                                            setValueBottomSheet();
                                            await getRecentHistory().then(
                                                (value) =>
                                                    Navigator.pop(context));
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg: "Try again later");
                                          }
                                          setStateSheet(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ).whenComplete(
                    () {
                      resetToOldValueBottomSheet();
                      if (selectedStatusNew == "All" &&
                          selectedTypeTrxNew == "All" &&
                          startDateNew == null) {
                        setState(() {
                          isFiltered = false;
                        });
                      } else {
                        setState(() {
                          isFiltered = true;
                        });
                      }
                    },
                  );
                },
                icon: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Icon(
                      Icons.tune,
                    ),
                    isFiltered
                        ? Icon(
                            Icons.circle,
                            size: 8,
                            color: redLableColor,
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
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
