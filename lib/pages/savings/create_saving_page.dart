import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/pages/savings/detail_saving_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/frequency_dropdown.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/set_reminder_widget.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';

class CreateSavingPage extends StatefulWidget {
  final SavingType savingType;
  const CreateSavingPage({super.key, required this.savingType});

  @override
  State<CreateSavingPage> createState() => _CreateSavingPageState();
}

class _CreateSavingPageState extends State<CreateSavingPage> {
  bool _isLoading = false;

  // DATE PICKER
  DateTime todayDate = DateTime.now();
  late DateTime allowedSelectDate;
  late DateTime dateValue;
  late String frequencyString;
  late int frequencyValue;
  late int resultNominal;

  // TIME PICKER
  TimeOfDay defaultTime = const TimeOfDay(hour: 12, minute: 0);
  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: defaultTime);
    if (time != null) {
      setState(() {
        defaultTime = time;
      });
    }
  }

  // CHECKBOX DAY
  List<String> selectedDay = ['Sunday'];

  // SWITCH
  bool switchValue = false;
  void changeSwitch(bool value) {
    setState(() {
      !value;
    });
  }

  final TextEditingController goalNameController =
      TextEditingController(text: "");
  final targetAmountController = TextEditingController(text: "");
  TextEditingController dateController = TextEditingController(text: "");

  late File _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
  void initState() {
    dateValue = DateTime(todayDate.year, todayDate.month, todayDate.day + 1);
    frequencyString = 'Daily';
    frequencyValue = getFrequencyValue(frequencyString);
    resultNominal = 0;
    allowedSelectDate =
        DateTime(todayDate.year, todayDate.month, todayDate.day + 1);
    _image = File("");
    super.initState();
  }

  void calculateResult() {
    int amount = int.parse(targetAmountController.text.replaceAll(",", ""));
    if (dateController.text.isNotEmpty) {
      int differentDay = dateValue.difference(todayDate).inDays;
      if (frequencyValue > differentDay) {
        setState(() {
          resultNominal = amount;
        });
      } else {
        setState(() {
          resultNominal = amount ~/ (differentDay ~/ frequencyValue);
        });
      }
    }
  }

  Future<void> handleCreateSaving() async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final SavingProvider savingProvider =
        Provider.of<SavingProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    await savingProvider.createSaving(
      authProvider.user.refreshToken,
      SavingRequest(
        goalName: goalNameController.text,
        targetAmount:
            (targetAmountController.text.replaceAll(",", "")).toString(),
        targetDate: dateValue,
        fillingNominal: resultNominal.toString(),
        fillingFrequency: frequencyString,
        dayReminder: selectedDay,
        savingType: widget.savingType,
        isReminder: switchValue ? 1 : 0,
        timeReminder: defaultTime.format(context),
        fillingType: "select_date",
      ),
      _image.path.isNotEmpty ? _image.path : '',
      (error) {
        setState(() {
          _isLoading = false;
        });
        ThrowSnackbar().showError(context, error.toString());
      },
    ).then((value) {
      if (value.id.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DetailSavingPage(
              saving: value,
            ),
          ),
          (route) => route.isFirst,
        );

        ThrowSnackbar().showError(context, "Succes Create Saving");
        // Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ThrowSnackbar().showError(context, "Gagal");
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget addImage() {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () {
            getImageFromGallery();
          },
          child: Container(
            width: double.infinity,
            color: greyBackgroundColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: blackColor,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "Add Image",
                  style: labelNormalTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget imageSelected() {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () {
            getImageFromGallery();
          },
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: blackColor.withOpacity(0.5),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: whiteColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: Text(
                        "TAP TO CHANGE",
                        style: labelNormalTextStyle.copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: primaryColor500,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        title: Text(
          "Set a New Filling Goal",
          style: headingNormalTextStyle.copyWith(
            color: whiteColor,
            fontWeight: semibold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _image.path.isNotEmpty ? imageSelected() : addImage(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: goalNameController,
                    labelText: "Goal Name",
                    hintText: "Input Your Goal Name",
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    onCompleted: () {
                      // String value = targetAmountController.text;
                      // print(int.parse(value.replaceAll(",", "")));
                      if (targetAmountController.text.isNotEmpty) {
                        calculateResult();
                      }
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (targetAmountController.text.isNotEmpty) {
                        calculateResult();
                      }
                    },
                    controller: targetAmountController,
                    labelText: "Target Amount",
                    hintText: "Input Your Target Amount",
                    isCurrency: true,
                    prefix: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Rp",
                        style: labelNormalTextStyle.copyWith(
                          fontWeight: semibold,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                        dateController.text =
                            DateFormat('dd MMMM yyyy').format(pickedDate);
                        if (targetAmountController.text.isNotEmpty) {
                          calculateResult();
                        }
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
                      if (targetAmountController.text.isNotEmpty) {
                        calculateResult();
                      }
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
                  const SizedBox(
                    height: 30,
                  ),
                  SetReminderWidget(
                    isActive: switchValue,
                    selectedDays: selectedDay,
                    onSwitchPressed: (bool value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                    timeValue: defaultTime,
                    onTimePressed: () => displayTimePicker(context),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            defaultShadow,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryButton(
            isLoading: _isLoading,
            onPressed: handleCreateSaving,
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
      ),
    );
  }

  @override
  void dispose() {
    goalNameController.dispose();
    targetAmountController.dispose();
    dateController.dispose();

    super.dispose();
  }
}
