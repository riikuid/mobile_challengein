// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challengein/widget/modal/menu_items.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/filter_model.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/modal/list_filter_modal.dart';
import 'package:mobile_challengein/widget/primary_button.dart';

class FilterModal extends StatefulWidget {
  final FilterModel? modelForedit;
  final MenuItem? item;
  final bool? isNested;
  const FilterModal({
    super.key,
    this.modelForedit,
    this.item,
    this.isNested,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  bool isLoading = false;
  bool isLoading1 = false;

  DateTime? startDateNew;
  DateTime? endDateNew;
  TextEditingController rangeDateTextControllerNew = TextEditingController();

  TextEditingController goalNameController = TextEditingController();
  TextEditingController lowestPriceController = TextEditingController();
  TextEditingController highestPriceController = TextEditingController();
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();

  List<String> filterConditions = ['AND', 'OR'];
  String selectedFilterCondition = 'AND';

  List goalNameConditions = [
    ['Contains', GoalNameCondition.contains],
    ["Doesn't contain", GoalNameCondition.doesntContain],
    ['Is', GoalNameCondition.iss],
    ["Is not", GoalNameCondition.isNot],
    ['Starts with', GoalNameCondition.startsWith],
    ['Ends with', GoalNameCondition.endsWith],
  ];

  String selectedTargetDateCondition = 'Is between';
  List<String> targetDateConditions = [
    'Is between',
    'Is after',
    'Is before',
  ];

  List<String> listTypeSaving = [
    'All',
    'Saving Record',
    'Wallet Saving',
  ];
  String selectedTypeSaving = 'All';

  List<FilterModel> tempNestedFilter = [];

  MenuItem? selectedMenuItem;
  // List<FilterModel> tempNestedFilter = [];

  GoalNameCondition selectedGoalNameCondition = GoalNameCondition.contains;

  void onSaveFilter() {
    if (goalNameController.text.isEmpty &&
        lowestPriceController.text.isEmpty &&
        highestPriceController.text.isEmpty &&
        startDateNew == null &&
        endDateNew == null) {
      Fluttertoast.showToast(msg: "Field can't be empty");
    } else {
      context.read<SavingProvider>().addFilter(
            item: FilterModel(
              id: const Uuid().v4(),
              goalName: goalNameController.text.isNotEmpty
                  ? goalNameController.text
                  : null,
              goalNameCondition: goalNameController.text.isNotEmpty
                  ? selectedGoalNameCondition
                  : null,
              lowesTargetAmound: lowestPriceController.text.isNotEmpty
                  ? int.parse(lowestPriceController.text)
                  : null,
              highestTargetAmound: highestPriceController.text.isNotEmpty
                  ? int.parse(highestPriceController.text)
                  : null,
              startTargetDate: startDateNew,
              endTargetDate: endDateNew,
              savingType: selectedTypeSaving == 'Saving Record'
                  ? SavingType.record
                  : selectedTypeSaving == 'Wallet Saving'
                      ? SavingType.wallet
                      : null,
              nestedFilter: tempNestedFilter,
              condiniton: selectedFilterCondition,
              menuItem: widget.item,
            ),
          );
      Navigator.pop(context);
    }
  }

  void onSaveForNested() {
    if (goalNameController.text.isEmpty &&
        lowestPriceController.text.isEmpty &&
        highestPriceController.text.isEmpty &&
        startDateNew == null &&
        endDateNew == null) {
      Fluttertoast.showToast(msg: "Field can't be empty");
    } else {
      FilterModel itemNested = FilterModel(
        id: const Uuid().v4(),
        goalName:
            goalNameController.text.isNotEmpty ? goalNameController.text : null,
        goalNameCondition: goalNameController.text.isNotEmpty
            ? selectedGoalNameCondition
            : null,
        lowesTargetAmound: lowestPriceController.text.isNotEmpty
            ? int.parse(lowestPriceController.text)
            : null,
        highestTargetAmound: highestPriceController.text.isNotEmpty
            ? int.parse(highestPriceController.text)
            : null,
        startTargetDate: startDateNew,
        endTargetDate: endDateNew,
        savingType: selectedTypeSaving == 'Saving Record'
            ? SavingType.record
            : selectedTypeSaving == 'Wallet Saving'
                ? SavingType.wallet
                : null,
        nestedFilter: tempNestedFilter,
        condiniton: selectedFilterCondition,
        menuItem: widget.item,
      );

      Navigator.pop(context, itemNested);
    }
  }

  void onUpdateForNested() {
    if (goalNameController.text.isEmpty &&
        lowestPriceController.text.isEmpty &&
        highestPriceController.text.isEmpty &&
        startDateNew == null &&
        endDateNew == null) {
      Fluttertoast.showToast(msg: "Field can't be empty");
    } else {
      log("kepanggil for nested");
      FilterModel itemNested = FilterModel(
        id: widget.modelForedit!.id,
        goalName:
            goalNameController.text.isNotEmpty ? goalNameController.text : null,
        goalNameCondition: goalNameController.text.isNotEmpty
            ? selectedGoalNameCondition
            : null,
        lowesTargetAmound: lowestPriceController.text.isNotEmpty
            ? int.parse(lowestPriceController.text)
            : null,
        highestTargetAmound: highestPriceController.text.isNotEmpty
            ? int.parse(highestPriceController.text)
            : null,
        startTargetDate: startDateNew,
        endTargetDate: endDateNew,
        nestedFilter: tempNestedFilter,
        condiniton: selectedFilterCondition,
        menuItem: widget.item,
      );

      Navigator.pop(context, itemNested);
    }
  }

  void onUpdateFilter() {
    if (goalNameController.text.isEmpty &&
        lowestPriceController.text.isEmpty &&
        highestPriceController.text.isEmpty &&
        startDateNew == null &&
        endDateNew == null) {
      Fluttertoast.showToast(msg: "Field can't be empty");
    } else {
      context.read<SavingProvider>().updateFilter(
              item: FilterModel(
            id: widget.modelForedit != null
                ? widget.modelForedit!.id
                : const Uuid().v4(),
            goalName: goalNameController.text.isNotEmpty
                ? goalNameController.text
                : null,
            goalNameCondition: goalNameController.text.isNotEmpty
                ? selectedGoalNameCondition
                : null,
            lowesTargetAmound: lowestPriceController.text.isNotEmpty
                ? int.parse(lowestPriceController.text)
                : null,
            highestTargetAmound: highestPriceController.text.isNotEmpty
                ? int.parse(highestPriceController.text)
                : null,
            startTargetDate: startDateNew,
            endTargetDate: endDateNew,
            nestedFilter: tempNestedFilter,
            condiniton: selectedFilterCondition,
            menuItem: widget.item,
          ));
      Navigator.pop(context);
    }
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10),
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
        rangeDateTextControllerNew.text = AppHelper.formatRangeDate(
            startDate: startDateNew!, endDate: endDateNew!);
      });
    }
  }

  @override
  void initState() {
    if (widget.modelForedit != null) {
      FilterModel item = widget.modelForedit!;

      // GOAL NAME
      if (widget.modelForedit!.goalName != null) {
        goalNameController.text = widget.modelForedit!.goalName!;
        selectedGoalNameCondition = widget.modelForedit!.goalNameCondition!;
      }

      // TARGET AMOUNT
      if (widget.modelForedit!.highestTargetAmound != null) {
        highestPriceController.text =
            (widget.modelForedit!.highestTargetAmound!).toString();
      }
      if (widget.modelForedit!.lowesTargetAmound != null) {
        lowestPriceController.text =
            (widget.modelForedit!.lowesTargetAmound!).toString();
      }

      // TARGET DATE
      if (item.startTargetDate != null && item.endTargetDate == null) {
        startDateNew = item.startTargetDate;
        startDateTextController.text =
            AppHelper.formatDateToString(item.startTargetDate!);
        selectedTargetDateCondition = 'Is after';
      } else if (item.startTargetDate == null && item.endTargetDate != null) {
        endDateNew = item.endTargetDate;
        endDateTextController.text =
            AppHelper.formatDateToString(item.endTargetDate!);
        selectedTargetDateCondition = 'Is before';
      } else if (item.startTargetDate != null && item.endTargetDate != null) {
        startDateNew = item.startTargetDate;
        endDateNew = item.endTargetDate;
        rangeDateTextControllerNew.text = AppHelper.formatRangeDate(
            startDate: startDateNew, endDate: endDateNew);
        selectedTargetDateCondition = 'Is between';
      }

      // CONDITION
      selectedFilterCondition = item.condiniton!;

      // MODEL NESTED
      if (item.nestedFilter != null) {
        tempNestedFilter = [...item.nestedFilter!];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateModal) {
        Widget _buildStatusTrx(
          String filter,
        ) {
          bool isSelected = selectedTypeSaving == filter;
          return GestureDetector(
            onTap: () {
              setStateModal(() {
                selectedTypeSaving = filter;
              });
              log(selectedTypeSaving);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? primaryColor500 : Colors.transparent,
                border: Border.all(
                    color: isSelected ? primaryColor500 : Colors.grey),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                filter,
                style: primaryTextStyle.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? regular : regular,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }

        Size screenSize = MediaQuery.of(context).size;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: (2 / 3) * screenSize.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.modelForedit != null
                          ? 'Customize Condition'
                          : 'Add New Condition',
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semibold,
                      ),
                    ),
                    if (widget.item == MenuItems.allRule ||
                        tempNestedFilter.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: subtitleTextColor,
                            style: BorderStyle.solid,
                            width: 0.80,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: false,
                            style: const TextStyle(
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                            value: selectedFilterCondition,
                            dropdownColor: whiteColor,
                            items: filterConditions
                                .map<DropdownMenuItem<String>>(
                                  (String item) => DropdownMenuItem<String>(
                                    value: item,
                                    // enabled: item == selectedFrequency,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                      ),
                                      child: Text(
                                        item,
                                        style:
                                            paragraphNormalTextStyle.copyWith(
                                          fontWeight: regular,
                                          color: subtitleTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setStateModal(() {
                                selectedFilterCondition = value!;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (widget.item == MenuItems.allRule ||
                            widget.item == MenuItems.name ||
                            widget.modelForedit?.goalName != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: medium,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                        color: subtitleTextColor,
                                        style: BorderStyle.solid,
                                        width: 0.80,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: false,
                                        style: const TextStyle(
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                        ),
                                        iconSize: 15,
                                        value: selectedGoalNameCondition,
                                        dropdownColor: whiteColor,
                                        items: goalNameConditions
                                            .map<DropdownMenuItem>(
                                              (item) => DropdownMenuItem(
                                                value: item[1],
                                                // enabled: item == selectedFrequency,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                  ),
                                                  child: Text(
                                                    item[0],
                                                    style:
                                                        paragraphNormalTextStyle
                                                            .copyWith(
                                                      fontWeight: regular,
                                                      color: subtitleTextColor,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setStateModal(() {
                                            log(value.toString());
                                            selectedGoalNameCondition = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextField(
                                textFieldType: CustomTextFieldType.outline,
                                controller: goalNameController,
                                borderRadius: 7,
                                labelText: '',
                                lableStyle: primaryTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                                hintText: "",
                                hintStyle: primaryTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: semibold,
                                  color: subtitleTextColor,
                                ),
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Saving Type',
                        //           style: primaryTextStyle.copyWith(
                        //             fontSize: 12,
                        //             fontWeight: medium,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       height: 10,
                        //     ),
                        //     Wrap(
                        //       spacing: 8,
                        //       runSpacing: 8,
                        //       children: [
                        //         ...listTypeSaving.map(
                        //           (e) {
                        //             return _buildStatusTrx(e);
                        //           },
                        //         )
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       height: 20,
                        //     ),
                        //   ],
                        // ),
                        if (widget.item == MenuItems.allRule ||
                            widget.item == MenuItems.targetAmount ||
                            widget.modelForedit?.highestTargetAmound != null ||
                            widget.modelForedit?.lowesTargetAmound != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Target Amount",
                                style: primaryTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      textFieldType:
                                          CustomTextFieldType.outline,
                                      controller: lowestPriceController,
                                      borderRadius: 7,
                                      labelText: "",
                                      prefix: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text("Rp"),
                                      ),
                                      hintText: "Lowest",
                                      hintStyle: primaryTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: semibold,
                                        color: subtitleTextColor,
                                      ),
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '-',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 20,
                                      fontWeight: semibold,
                                      color: subtitleTextColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      textFieldType:
                                          CustomTextFieldType.outline,
                                      controller: highestPriceController,
                                      borderRadius: 7,
                                      labelText: "",
                                      prefix: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text("Rp"),
                                      ),
                                      hintText: "Highest",
                                      hintStyle: primaryTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: semibold,
                                        color: subtitleTextColor,
                                      ),
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        if (widget.item == MenuItems.allRule ||
                            widget.item == MenuItems.targetDate ||
                            widget.modelForedit?.startTargetDate != null ||
                            widget.modelForedit?.endTargetDate != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Target Date',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: medium,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                        color: subtitleTextColor,
                                        style: BorderStyle.solid,
                                        width: 0.80,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: false,
                                        style: const TextStyle(
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                        ),
                                        iconSize: 15,
                                        value: selectedTargetDateCondition,
                                        dropdownColor: whiteColor,
                                        items: targetDateConditions
                                            .map<DropdownMenuItem>(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                value: item,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                  ),
                                                  child: Text(
                                                    item,
                                                    style:
                                                        paragraphNormalTextStyle
                                                            .copyWith(
                                                      fontWeight: regular,
                                                      color: subtitleTextColor,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setStateModal(() {
                                            log(value.toString());

                                            startDateNew = null;
                                            startDateTextController.clear;

                                            endDateNew = null;
                                            endDateTextController.clear;
                                            rangeDateTextControllerNew.clear();

                                            selectedTargetDateCondition =
                                                value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (selectedTargetDateCondition == 'Is after')
                                CustomTextField(
                                  labelText: "",
                                  hintText: 'Pick a Start Date',
                                  hintStyle: primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semibold,
                                    color: subtitleTextColor,
                                  ),
                                  keyboardType: TextInputType.name,
                                  controller: startDateTextController,
                                  prefix: const SizedBox(
                                    width: 15,
                                  ),
                                  textFieldType: CustomTextFieldType.outline,
                                  isPicker: true,
                                  pickerFunction: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2050),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: primaryColor500,
                                              onPrimary: whiteColor,
                                              surface: primaryColor50,
                                              onSurface: blackColor,
                                              onInverseSurface: blackColor,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedDate != null) {
                                      startDateNew = pickedDate;
                                      startDateTextController.text =
                                          DateFormat('dd MMM yyyy')
                                              .format(pickedDate);
                                    }
                                  },
                                ),
                              if (selectedTargetDateCondition == 'Is before')
                                CustomTextField(
                                  labelText: '',
                                  hintText: 'Pick a End Date',
                                  hintStyle: primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semibold,
                                    color: subtitleTextColor,
                                  ),
                                  keyboardType: TextInputType.name,
                                  controller: endDateTextController,
                                  prefix: const SizedBox(
                                    width: 15,
                                  ),
                                  textFieldType: CustomTextFieldType.outline,
                                  isPicker: true,
                                  pickerFunction: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2050),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: primaryColor500,
                                              onPrimary: whiteColor,
                                              surface: primaryColor50,
                                              onSurface: blackColor,
                                              onInverseSurface: blackColor,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedDate != null) {
                                      endDateNew = pickedDate;
                                      endDateTextController.text =
                                          DateFormat('dd MMM yyyy')
                                              .format(pickedDate);
                                    }
                                  },
                                ),
                              if (selectedTargetDateCondition == 'Is between')
                                CustomTextField(
                                  labelText: '',
                                  hintText: 'Pick a Range Date',
                                  hintStyle: primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semibold,
                                    color: subtitleTextColor,
                                  ),
                                  keyboardType: TextInputType.name,
                                  controller: rangeDateTextControllerNew,
                                  prefix: const SizedBox(
                                    width: 15,
                                  ),
                                  textFieldType: CustomTextFieldType.outline,
                                  isPicker: true,
                                  pickerFunction: _showDateRangePicker,
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),

                        ...tempNestedFilter.map(
                          (filter) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  // height: 100,
                                  width: screenSize.width,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 1.0,
                                      color: primaryColor500,
                                    ),
                                  ),
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      elevation: 2,
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: primaryColor50,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: subtitleTextColor,
                                          style: BorderStyle.none,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet<FilterModel?>(
                                        shape: const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return FilterModal(
                                            modelForedit: filter,
                                            item: filter.menuItem,
                                            isNested: true,
                                          );
                                        },
                                      ).then(
                                        (value) {
                                          if (value != null) {
                                            log('value id = ${value.id ?? 'kosong'}');
                                            setStateModal(() {
                                              tempNestedFilter =
                                                  tempNestedFilter.map(
                                                (e) {
                                                  if (e.id == value.id) {
                                                    return value;
                                                  }
                                                  return e;
                                                },
                                              ).toList();
                                            });
                                          }
                                        },
                                      );
                                    },
                                    alignment: Alignment.topLeft,
                                    icon: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '(${filter.condiniton ?? ''}) Filter',
                                          style: primaryTextStyle.copyWith(
                                            // color: blackColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        if (filter.goalName != null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Name',
                                                    style: primaryTextStyle
                                                        .copyWith(
                                                      color: subtitleTextColor,
                                                      fontWeight: regular,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    " (${AppHelper.formatConditionFilter(filter.goalNameCondition)})",
                                                    style: primaryTextStyle
                                                        .copyWith(
                                                      color: subtitleTextColor,
                                                      fontWeight: regular,
                                                      fontSize: 9,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                filter.goalName ?? '',
                                                textAlign: TextAlign.center,
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  fontWeight: regular,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        if (filter.lowesTargetAmound != null ||
                                            filter.highestTargetAmound != null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Target Amount',
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  color: subtitleTextColor,
                                                  fontWeight: regular,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                AppHelper.formatRangeAmount(
                                                  amount1:
                                                      filter.lowesTargetAmound,
                                                  amount2: filter
                                                      .highestTargetAmound,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  fontWeight: regular,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        if (filter.startTargetDate != null ||
                                            filter.endTargetDate != null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Target Date',
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  color: subtitleTextColor,
                                                  fontWeight: regular,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                AppHelper.formatRangeDate(
                                                  startDate:
                                                      filter.startTargetDate,
                                                  endDate: filter.endTargetDate,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  fontWeight: regular,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: -5,
                                  child: IconButton(
                                    onPressed: () {
                                      setStateModal(() {
                                        tempNestedFilter.removeWhere(
                                          (element) => element.id == filter.id,
                                        );
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: secondaryColor600,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 60,
                          width: screenSize.width,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              customButton: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: primaryColor500,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      border: Border.all(
                                        width: 1.5,
                                        color: primaryColor500,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 12,
                                      weight: 8,
                                      color: whiteColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add New Conditions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: light,
                                      color: subtitleTextColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              items: [
                                DropdownMenuItem<Divider>(
                                    enabled: false,
                                    child: Text(
                                      'Filter by',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 10,
                                        color:
                                            subtitleTextColor.withOpacity(0.7),
                                      ),
                                    )),
                                ...MenuItems.firstItems.map(
                                  (item) => DropdownMenuItem<MenuItem>(
                                    value: item,
                                    child: MenuItems.buildFirstItem(item),
                                  ),
                                ),
                                const DropdownMenuItem<Divider>(
                                  enabled: false,
                                  child: Divider(),
                                ),
                                ...MenuItems.secondItems.map(
                                  (item) => DropdownMenuItem<MenuItem>(
                                    value: item,
                                    child: MenuItems.buildSecondItem(item),
                                  ),
                                ),
                              ],
                              value: selectedMenuItem,
                              onChanged: (value) {
                                setStateModal(() {
                                  selectedMenuItem = value as MenuItem;
                                });
                                MenuItems.onChanged(
                                  context: context,
                                  item: value! as MenuItem,
                                  isNested: true,
                                  callback: (p0) {
                                    log("ini value nested $p0");
                                    if (p0 != null) {
                                      setStateModal(() {
                                        tempNestedFilter.add(p0);
                                      });
                                    }
                                  },
                                );
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 500,
                                // width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: primaryColor50,
                                ),
                              ),
                              iconStyleData: IconStyleData(
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 0,
                                iconEnabledColor: primaryColor500,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 500,
                                isOverButton: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    width: 0.5,
                                    color: primaryColor300,
                                  ),
                                  color: whiteColor,
                                ),
                                offset: const Offset(0, 220),
                                elevation: 0,
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: MaterialStateProperty.all(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                customHeights: [
                                  20,
                                  ...List<double>.filled(
                                      MenuItems.firstItems.length, 40),
                                  10,
                                  ...List<double>.filled(
                                      MenuItems.secondItems.length, 40),
                                ],
                                // height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                PrimaryButton(
                  isLoading: isLoading,
                  isEnabled: !isLoading1,
                  height: 40,
                  child: Text(
                    "SAVE",
                    style: primaryTextStyle.copyWith(
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    setStateModal(() {
                      isLoading = true;
                    });
                    // log('modal' +
                    //     (widget.modelForedit != null).toString() +
                    //     widget.isNested.toString());
                    log(((widget.isNested ?? false) &&
                            widget.modelForedit != null)
                        .toString());

                    if ((widget.isNested ?? false) &&
                        widget.modelForedit != null) {
                      log("kepanggil onUpdateForNested()");
                      onUpdateForNested();
                      return;
                    } else if (widget.modelForedit != null) {
                      log("kepanggil onUpdateFilter()");
                      onUpdateFilter();
                      return;
                    } else if ((widget.isNested ?? false)) {
                      log("kepanggil onSaveForNested()");
                      onSaveForNested();
                      return;
                    } else {
                      log("kepanggil onSaveFilter()");
                      onSaveFilter();
                    }

                    // widget.modelForedit != null
                    //     ? onUpdateFilter()
                    //     : (widget.isNested ?? false)
                    //         ? onSaveForNested()
                    //         : ((widget.isNested ?? false) &&
                    //                 widget.modelForedit != null)
                    //             ? onUpdateForNested()
                    //             : onSaveFilter();

                    setStateModal(() {
                      isLoading = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
