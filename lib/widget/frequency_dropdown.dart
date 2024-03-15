import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';

class FrequencyDropdown extends StatelessWidget {
  final String selectedValue;
  final void Function(String?)? onSelectedItem;
  const FrequencyDropdown(
      {super.key, required this.selectedValue, this.onSelectedItem});

  @override
  Widget build(BuildContext context) {
    List<String> fillingFrequencyItem = ['Daily', 'Weekly', 'Monthly'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Filling Frequency",
          style: labelLargeTextStyle.copyWith(
            fontWeight: semibold,
          ),
        ),
        DropdownButton(
          underline: SizedBox(
            height: 1,
            child: ColoredBox(
              color: disabledColor,
            ),
          ),
          isExpanded: true,
          value: selectedValue,
          itemHeight: 60,
          dropdownColor: whiteColor,
          // style: TextField.materialMisspelledTextStyle,
          items: fillingFrequencyItem
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
                      style: paragraphNormalTextStyle.copyWith(
                        fontWeight: light,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onSelectedItem,
        ),
      ],
    );
  }
}
