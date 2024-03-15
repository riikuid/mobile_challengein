// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_challengein/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
        text,
        style: headingNormalTextStyle.copyWith(
          color: whiteColor,
          fontWeight: semibold,
          fontSize: 16,
        ),
      ),
    );
  }
}
