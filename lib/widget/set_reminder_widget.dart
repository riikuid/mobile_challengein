// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_switch.dart';

class SetReminderWidget extends StatefulWidget {
  final bool isActive;
  final List<String> selectedDays;
  final Function(bool) onSwitchPressed;
  final void Function() onTimePressed;
  final TimeOfDay timeValue;

  const SetReminderWidget({
    super.key,
    required this.isActive,
    required this.selectedDays,
    required this.onSwitchPressed,
    required this.onTimePressed,
    required this.timeValue,
  });

  @override
  State<SetReminderWidget> createState() => _SetReminderWidgetState();
}

class _SetReminderWidgetState extends State<SetReminderWidget> {
  List<String> dayOnWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reminder",
              style: labelLargeTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            CustomSwitch(
              height: 20,
              width: 40,
              value: widget.isActive,
              enableColor: primaryColor500,
              disableColor: disabledColor,
              onChanged: widget.onSwitchPressed,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        MaterialButton(
          padding: const EdgeInsets.all(0),
          onPressed: widget.isActive ? widget.onTimePressed : null,
          child: IntrinsicWidth(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.timeValue.format(context),
                  style: headingExtraLargeTextStyle.copyWith(
                    fontWeight: semibold,
                    color: widget.isActive
                        ? subtitleTextColor
                        : subtitleTextColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.edit_note_sharp,
                  color: widget.isActive
                      ? subtitleTextColor
                      : subtitleTextColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
        // Wrap(
        //   spacing: 8.0, // Spasi horizontal antar item
        //   runSpacing: -8.0, // Spasi vertikal antar item
        //   children: List.generate(
        //     dayOnWeek.length,
        //     (index) {
        //       return TextButton(
        //         onPressed: widget.isActive
        //             ? () {
        //                 setState(() {
        //                   if (widget.selectedDays.contains(dayOnWeek[index])) {
        //                     if (widget.selectedDays.length > 1) {
        //                       widget.selectedDays.remove(dayOnWeek[index]);
        //                     }
        //                   } else {
        //                     widget.selectedDays.add(dayOnWeek[index]);
        //                   }
        //                   // selectedDay.add(dayOnWeek[index]);
        //                 });
        //                 debugPrint(widget.selectedDays.toString());
        //               }
        //             : null,
        //         style: TextButton.styleFrom(
        //           backgroundColor: widget.isActive
        //               ? widget.selectedDays.contains(dayOnWeek[index])
        //                   ? primaryColor50
        //                   : transparentColor
        //               : transparentColor,
        //           minimumSize: const Size(50, 30),
        //           maximumSize: const Size(100, 30),
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 12,
        //             vertical: 0,
        //           ),
        //           side: BorderSide(
        //             color: widget.isActive
        //                 ? widget.selectedDays.contains(dayOnWeek[index])
        //                     ? primaryColor500
        //                     : subtitleTextColor
        //                 : subtitleTextColor.withOpacity(0.5),
        //           ),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(6.0),
        //           ),
        //         ),
        //         child: Text(
        //           dayOnWeek[index],
        //           style: labelNormalTextStyle.copyWith(
        //             color: widget.isActive
        //                 ? widget.selectedDays.contains(dayOnWeek[index])
        //                     ? primaryColor500
        //                     : subtitleTextColor
        //                 : subtitleTextColor.withOpacity(0.5),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
