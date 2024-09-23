import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_challengein/common/app_helper.dart';
import 'package:mobile_challengein/model/filter_saving_model.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  bool isLoading = false;
  bool isLoading1 = false;

  DateTime? startDateNew;
  DateTime? endDateNew;
  TextEditingController rangeDateTextControllerNew = TextEditingController();

  final TextEditingController goalNameController = TextEditingController();
  TextEditingController lowestPriceController = TextEditingController();
  TextEditingController highestPriceController = TextEditingController();

  List<String> fillingFrequencyItem = ['AND', 'OR'];
  String selectedValue = 'AND';

  List goalNameConditions = [
    ['Contains', GoalNameCondition.contains],
    ["Doesn't contain", GoalNameCondition.doesntContain],
    ['Is', GoalNameCondition.iss],
    ["Is not", GoalNameCondition.isNot],
    ['Starts with', GoalNameCondition.startsWith],
    ['Ends with', GoalNameCondition.endsWith],
  ];
  GoalNameCondition selectedGoalNameCondition = GoalNameCondition.contains;

  void onSaveFilter() {
    if (goalNameController.text.isEmpty &&
        lowestPriceController.text.isEmpty &&
        highestPriceController.text.isEmpty &&
        startDateNew == null) {
      Fluttertoast.showToast(msg: "Field can't be empty");
    } else {
      context.read<SavingProvider>().addFilter(
              item: FilterSavingModel(
            id: const Uuid().v4(),
            goalName: goalNameController.text.isNotEmpty
                ? goalNameController.text
                : '',
            goalNameCondition: selectedGoalNameCondition,
            lowesTargetAmound: int.parse(lowestPriceController.text.isNotEmpty
                ? lowestPriceController.text
                : '0'),
            highestTargetAmound: int.parse(
                highestPriceController.text.isNotEmpty
                    ? highestPriceController.text
                    : '100000000'),
            startTargetDate: startDateNew,
            endTargetDate: endDateNew,
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
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateModal) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Conditions',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semibold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Goal Name',
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                          decorationStyle: TextDecorationStyle.solid,
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
                                    style: paragraphNormalTextStyle.copyWith(
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
                      textFieldType: CustomTextFieldType.outline,
                      controller: lowestPriceController,
                      borderRadius: 7,
                      labelText: "",
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Rp"),
                      ),
                      hintText: "Lowest Price",
                      hintStyle: primaryTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                        color: subtitleTextColor,
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextField(
                      textFieldType: CustomTextFieldType.outline,
                      controller: highestPriceController,
                      borderRadius: 7,
                      labelText: "",
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Rp"),
                      ),
                      hintText: "Highest Price",
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
              Text(
                'Target Date',
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              CustomTextField(
                labelText: "",
                hintText: "Select Date",
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

                  onSaveFilter();

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
        );
      },
    );
  }
}
