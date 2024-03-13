// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_challengein/theme.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget? prefix;
  final TextInputType keyboardType;
  final bool isCurrency;
  final TextEditingController controller;
  final VoidCallback? onCompleted;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.prefix,
    required this.keyboardType,
    this.isCurrency = false,
    required this.controller,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: labelLargeTextStyle.copyWith(
            fontWeight: semibold,
          ),
        ),
        TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          inputFormatters: [
            isCurrency
                ? CurrencyTextInputFormatter(
                    decimalDigits: 0,
                    maxValue: 1000000000,
                    name: "",
                  )
                : TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue;
                  }),
          ],
          onEditingComplete: onCompleted,
          keyboardType: keyboardType,
          controller: controller,
          style: paragraphNormalTextStyle,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            hintText: hintText,
            hintStyle: paragraphNormalTextStyle.copyWith(
              color: subtitleTextColor,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: disabledColor,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor500,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 20,
              maxWidth: 30,
            ),
            prefixIcon: prefix,
          ),
        )
      ],
    );
  }
}
