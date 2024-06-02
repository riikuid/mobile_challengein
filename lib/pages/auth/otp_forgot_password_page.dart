import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:mobile_challengein/pages/auth/input_forgot_password_page.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpForgotPasswordPage extends StatefulWidget {
  final String email;
  const OtpForgotPasswordPage({super.key, required this.email});

  @override
  State<OtpForgotPasswordPage> createState() => _OtpForgotPasswordPageState();
}

class _OtpForgotPasswordPageState extends State<OtpForgotPasswordPage> {
  late TextEditingController codeController;
  Duration _requestTimer = const Duration(seconds: 60);
  bool _enableRequest = false;
  bool _isLoading = false;
  String _errorText = "Something went wrong!";

  @override
  void initState() {
    codeController = TextEditingController(text: "");
    super.initState();
  }

  void handleResendCode() {
    AuthProvider().reqCode(
      email: widget.email,
      isForgotPassword: true,
    );
    setState(() {
      _enableRequest = false;
      _requestTimer = _requestTimer;
    });
  }

  Future<void> handleActivation() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    await authProvider
        .checkCodeForgotPassword(
      code: codeController.text,
      errorCallback: (e) => setState(() {
        _errorText = e;
      }),
    )
        .then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => InputForgotPasswordPage(
                code: codeController.text,
              ),
            ),
            (route) => false);
      } else {
        ThrowSnackbar().showError(context, _errorText);
      }
    });

    setState(() {
      _isLoading = false;
    });

    // return loginStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/icon/icon_logo_only.svg",
                width: 55,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Verify OTP",
                style: headingLargeTextStyle.copyWith(
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                  // text: "Hello A temporary s",
                  style: paragraphNormalTextStyle.copyWith(
                    height: 1.5,
                    fontWeight: regular,
                    color: subtitleTextColor,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'A temporary activation code was sent to ',
                    ),
                    TextSpan(
                        text: widget.email,
                        style: primaryTextStyle.copyWith(
                            fontWeight: medium, color: primaryColor600)),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              PinCodeTextField(
                appContext: context,
                length: 4,
                pastedTextStyle: primaryTextStyle,
                keyboardType: TextInputType.name,
                textStyle: headingMediumTextStyle.copyWith(
                  color: subtitleTextColor,
                  fontWeight: semibold,
                ),
                controller: codeController,
                enableActiveFill: true,
                cursorColor: primaryColor500,
                animationType: AnimationType.fade,
                blinkWhenObscuring: true,
                animationDuration: const Duration(milliseconds: 300),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 80,
                  fieldWidth: 68,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  borderWidth: 0.5,
                  activeBorderWidth: 0.5,
                  errorBorderWidth: 0.5,
                  inactiveBorderWidth: 0.5,
                  selectedBorderWidth: 0.8,
                  // disabledColor: primaryColor50,
                  // errorBorderColor: BaseColors.danger500,
                  activeFillColor: primaryColor50,
                  activeColor: primaryColor200,
                  inactiveFillColor: secondaryColor50,
                  inactiveColor: secondaryColor200,
                  selectedColor: primaryColor500,
                  selectedFillColor: primaryColor50,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              PrimaryButton(
                isLoading: _isLoading,
                onPressed: handleActivation,
                child: Text(
                  "VERIFY",
                  style: headingNormalTextStyle.copyWith(
                    color: whiteColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't get the code?",
                    style: paragraphNormalTextStyle.copyWith(
                      color: subtitleTextColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _enableRequest
                      ? GestureDetector(
                          onTap: handleResendCode,
                          child: Text(
                            "Resend Code",
                            style: paragraphNormalTextStyle.copyWith(
                              color: primaryColor500,
                              fontWeight: medium,
                              height: 1,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor500,
                              decorationThickness: 1.5,
                              // decorationStyle: TextDecorationStyle.double,
                            ),
                          ),
                        )
                      : TimerCountdown(
                          format: CountDownTimerFormat.minutesSeconds,
                          onEnd: () => setState(() {
                            _enableRequest = true;
                          }),
                          enableDescriptions: false,
                          spacerWidth: 0,
                          endTime: DateTime.now().add(_requestTimer),
                          colonsTextStyle: paragraphNormalTextStyle.copyWith(
                            fontWeight: medium,
                            height: 1,
                            // decorationStyle: TextDecorationStyle.double,
                          ),
                          timeTextStyle: paragraphNormalTextStyle.copyWith(
                            fontWeight: medium,
                            height: 1,
                            // decorationStyle: TextDecorationStyle.double,
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
