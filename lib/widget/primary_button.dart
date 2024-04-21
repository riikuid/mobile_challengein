// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mobile_challengein/theme.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool? isLoading;
  final bool? isEnabled;
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isLoading! ? onPressed : () {},
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        backgroundColor: !isLoading! ? primaryColor500 : disabledColor,
        minimumSize: const Size(
          double.infinity,
          40,
        ),
      ),
      child: !isLoading!
          ? child
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Loading",
                  style: primaryTextStyle.copyWith(
                    fontWeight: semibold,
                    fontSize: 16,
                    color: whiteColor,
                  ),
                )
              ],
            ),
    );
  }
}
