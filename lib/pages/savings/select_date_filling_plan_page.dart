// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/frequency_dropdown.dart';

class SelectDateFillingPlanPage extends StatefulWidget {
  final DateTime? estimationDate;
  final String? estimationDateString;
  final String? frequencyString;
  final int? fillingNominal;
  final int targetAmount;
  const SelectDateFillingPlanPage({
    super.key,
    this.estimationDate,
    this.estimationDateString,
    required this.targetAmount,
    this.frequencyString,
    this.fillingNominal,
  });

  @override
  State<SelectDateFillingPlanPage> createState() =>
      _SelectDateFillingPlanPageState();
}

class _SelectDateFillingPlanPageState extends State<SelectDateFillingPlanPage> {
  DateTime todayDate = DateTime.now();
  TextEditingController dateController = TextEditingController(text: "");
  late DateTime dateValue;
  late String frequencyString;
  late int frequencyValue;
  late int resultNominal;

  @override
  void initState() {
    dateValue = widget.estimationDate ??
        DateTime(todayDate.year, todayDate.month, todayDate.day + 1);
    dateController.text = widget.estimationDateString ?? "";
    frequencyString = widget.frequencyString ?? 'Daily';
    frequencyValue = getFrequencyValue(frequencyString);
    resultNominal = widget.fillingNominal ?? 0;
    super.initState();
  }

  int getFrequencyValue(String value) {
    int frequencyValue;

    switch (value) {
      case 'Daily':
        frequencyValue = 1;
        break;
      case 'Weekly':
        frequencyValue = 7;
        break;
      case 'Monthly':
        frequencyValue = 30;
        break;
      default:
        frequencyValue = 1;
    }

    return frequencyValue;
  }

  @override
  Widget build(BuildContext context) {
    DateTime allowedSelectDate =
        DateTime(todayDate.year, todayDate.month, todayDate.day + 1);

    void calculateResult() {
      if (dateController.text.isNotEmpty) {
        int differentDay = dateValue.difference(todayDate).inDays;
        if (frequencyValue > differentDay) {
          setState(() {
            resultNominal = widget.targetAmount.toInt();
          });
        } else {
          setState(() {
            resultNominal =
                widget.targetAmount ~/ (differentDay ~/ frequencyValue);
          });
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: dateController,
              labelText: "Target Date",
              hintText: "Select Your Target Date",
              isCurrency: true,
              prefix: const Padding(
                padding: EdgeInsets.only(
                  right: 12.0,
                  bottom: 4,
                ),
                child: Icon(Icons.date_range),
              ),
              keyboardType: TextInputType.number,
              isPicker: true,
              pickerFunction: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dateValue,
                  firstDate: allowedSelectDate,
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
                  dateValue = pickedDate;
                  String formattedDate =
                      DateFormat('dd MMMM yyyy').format(pickedDate);

                  dateController.text = formattedDate;
                  calculateResult();
                } else {}
              },
            ),
            const SizedBox(
              height: 20,
            ),
            FrequencyDropdown(
              selectedValue: frequencyString,
              onSelectedItem: (value) {
                setState(() {
                  frequencyString = value!;
                  frequencyValue = getFrequencyValue(value);
                });
                calculateResult();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Recommended Filling Nominal",
              style: labelLargeTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Rp${NumberFormat('#,##0').format(resultNominal)}",
              style: labelLargeTextStyle.copyWith(
                fontWeight: semibold,
                color: primaryColor600,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ElevatedButton(
            onPressed: () {
              print(dateController.text);
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              backgroundColor: primaryColor500,
              minimumSize: const Size(
                double.infinity,
                40,
              ),
            ),
            child: Text(
              "SAVE",
              style: headingNormalTextStyle.copyWith(
                color: whiteColor,
                fontWeight: semibold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
