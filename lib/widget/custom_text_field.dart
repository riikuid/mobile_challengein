// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_challengein/theme.dart';

enum CustomTextFieldType { underline, outline }

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final Widget? prefix;
  final TextInputType keyboardType;
  final bool isCurrency;
  final TextEditingController controller;
  final VoidCallback? onCompleted;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool? isPicker;
  final void Function()? pickerFunction;
  final bool? isPassword;
  final bool? isObscure;
  final Widget? rightIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? enableTooltip;
  final bool? enableError;
  final String? errorText;

  final CustomTextFieldType? textFieldType;

  const CustomTextField({
    super.key,
    // this.focusNode = FocusNode(),
    required this.labelText,
    required this.hintText,
    this.prefix,
    required this.keyboardType,
    this.isCurrency = false,
    required this.controller,
    this.onCompleted,
    this.onChanged,
    this.onTapOutside,
    this.isPicker = false,
    this.pickerFunction,
    this.isPassword = false,
    this.isObscure,
    this.rightIcon,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.style,
    this.hintStyle,
    this.errorText = "Can not be empty",
    this.enableTooltip = false,
    this.textFieldType = CustomTextFieldType.underline,
    this.enableError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText!.isNotEmpty
            ? Row(
                children: [
                  Text(
                    labelText!,
                    style: labelLargeTextStyle.copyWith(
                      fontWeight: semibold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  enableTooltip!
                      ? Tooltip(
                          exitDuration: const Duration(seconds: 2),
                          textStyle: labelSmallTextStyle.copyWith(
                            fontSize: 12,
                            color: whiteColor,
                          ),
                          message:
                              "Password must:\n- Be between 9 and 64 character\n- Have one number\n- Have one uppercase character\n- Have one special character",
                          child: Icon(
                            Icons.info_outline,
                            size: 14,
                            color: subtitleTextColor,
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: textFieldType == CustomTextFieldType.underline
                ? Colors.transparent
                : Colors.white,
          ),
          child: TextField(
            focusNode: focusNode,
            onTapOutside: onTapOutside,
            onTap: isPicker! ? pickerFunction : null,
            inputFormatters: [
              isCurrency
                  ? CurrencyTextInputFormatter(
                      decimalDigits: 0,
                      maxValue: 100000000,
                      name: "",
                    )
                  : TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue;
                    }),
            ],
            onEditingComplete: onCompleted,
            onChanged: onChanged,
            // onSubmitted: (value) {
            //   FocusManager.instance.primaryFocus?.unfocus();
            // },
            obscureText: isPassword! ? isObscure! : false,
            readOnly: isPicker!,
            keyboardType: keyboardType,
            controller: controller,
            style: style ?? paragraphNormalTextStyle,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              error: enableError! ? Text(errorText!) : null,
              errorBorder: enableError!
                  ? textFieldType == CustomTextFieldType.underline
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        )
                      : const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        )
                  : null,
              hoverColor: Colors.red,
              contentPadding: textFieldType == CustomTextFieldType.underline
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
              hintText: hintText,
              hintStyle: hintStyle ??
                  paragraphNormalTextStyle.copyWith(
                    color: subtitleTextColor,
                  ),
              enabledBorder: textFieldType == CustomTextFieldType.underline
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: disabledColor,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: disabledColor,
                      ),
                    ),
              focusedBorder: textFieldType == CustomTextFieldType.underline
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isPicker! ? disabledColor : primaryColor500,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: isPicker! ? disabledColor : primaryColor500,
                        width: isPicker! ? 1 : 2,
                      ),
                    ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 20,
                maxWidth: 50,
              ),
              prefixIcon: prefix,
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 20,
              ),
              suffix: isPassword! ? rightIcon : null,
            ),
          ),
        ),
      ],
    );
  }
}
