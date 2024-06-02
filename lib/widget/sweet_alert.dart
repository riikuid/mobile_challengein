// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';

class SweetAlert extends StatelessWidget {
  final Widget? headIcon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onTap;
  const SweetAlert({
    super.key,
    this.headIcon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onTap,
  });

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
            headIcon ?? const SizedBox(),
            Text(
              title,
              style: headingMediumTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: paragraphLargeTextStyle.copyWith(
                fontSize: 12,
                color: subtitleTextColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              elevation: 0,
              color: secondaryColor500,
              onPressed: onTap ??
                  () async {
                    Navigator.pop(
                      context,
                    );
                  },
              child: Text(
                buttonText ?? "OKAY",
                style: paragraphNormalTextStyle.copyWith(
                  color: whiteColor,
                  fontWeight: regular,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
