// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';

class CustomAlert extends StatefulWidget {
  final VoidCallback onConfirmationText;
  final String title;
  final String subTitle;
  final String confirmationText;
  const CustomAlert({
    super.key,
    required this.onConfirmationText,
    required this.title,
    required this.subTitle,
    required this.confirmationText,
  });

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteColor,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: IntrinsicHeight(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: secondaryColor500.withOpacity(0.3),
              child: Icon(
                Icons.error,
                size: 30,
                color: secondaryColor500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.title,
              style: headingMediumTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.subTitle,
              textAlign: TextAlign.center,
              style: paragraphLargeTextStyle.copyWith(
                fontSize: 12,
                color: subtitleTextColor,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      elevation: 0,
                      color: transparentColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: paragraphNormalTextStyle.copyWith(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      elevation: 0,
                      color: secondaryColor500,
                      onPressed: widget.onConfirmationText,
                      child: Text(
                        widget.confirmationText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
