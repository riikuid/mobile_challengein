import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_challengein/screen/savings/filling_plan_page.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/set_reminder_widget.dart';

class CreateSavingPage extends StatefulWidget {
  const CreateSavingPage({super.key});

  @override
  State<CreateSavingPage> createState() => _CreateSavingPageState();
}

class _CreateSavingPageState extends State<CreateSavingPage> {
  // DATE PICKER
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

  @override
  void initState() {
    _image = File("");
    super.initState();
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
                  // DropdownMenu<String>(
                  //   hintText: "Select Your Filling Frequency",
                  //   // initialSelection: fillingFrequencyItem.first,
                  //   expandedInsets: const EdgeInsets.all(0),
                  //   menuStyle: MenuStyle(
                  //     side: MaterialStatePropertyAll(
                  //       BorderSide.none,
                  //     ),
                  //   ),
                  //   onSelected: (String? value) {
                  //     // This is called when the user selects an item.
                  //     setState(() {
                  //       // dropdownValue = value!;
                  //     });
                  //   },
                  //   dropdownMenuEntries: fillingFrequencyItem
                  //       .map<DropdownMenuEntry<String>>((String value) {
                  //     return DropdownMenuEntry<String>(
                  //         value: value, label: value);
                  //   }).toList(),
                  // ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Filling Plan",
                        style: labelLargeTextStyle.copyWith(
                          fontWeight: semibold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (targetAmountController.text.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FillingPlanPage(
                                      targetAmount: int.parse(
                                          targetAmountController.text
                                              .replaceAll(",", ""))),
                                ));
                          } else {
                            Fluttertoast.showToast(
                              msg: "Target Amount Shouldn't Be Empty",
                              timeInSecForIosWeb: 1,
                              fontSize: 14.0,
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(50, 23),
                          maximumSize: const Size(100, 23),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          side: BorderSide(
                            color: primaryColor500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          "SET UP",
                          style: labelSmallTextStyle.copyWith(
                            color: primaryColor500,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Filling Plan Hasn't Been Set",
                    style: paragraphNormalTextStyle.copyWith(
                      color: subtitleTextColor,
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
          child: ElevatedButton(
            onPressed: () {},
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
      ),
    );
  }
}
