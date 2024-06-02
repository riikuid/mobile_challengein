import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/pages/auth/otp_forgot_password_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';

import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController emailController;
  bool _isLoading = false;
  String error = "Failed to send code";

  Future<void> handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    await context
        .read<AuthProvider>()
        .reqCode(
          email: emailController.text,
          isForgotPassword: true,
          errorCallback: (p0) => setState(() {
            error = p0;
          }),
        )
        .then(
      (value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OtpForgotPasswordPage(email: emailController.text),
            ),
          );
        } else {
          ThrowSnackbar().showError(context, error);
        }
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    emailController = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                "Forgot Password?",
                style: headingLargeTextStyle.copyWith(
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Please enter your email address to\nreceive a verification code",
                style: paragraphNormalTextStyle.copyWith(
                  height: 0,
                  fontWeight: regular,
                  color: subtitleTextColor,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomTextField(
                textInputAction: TextInputAction.next,
                labelText: "Email Address",
                hintText: "example@mail.com",
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // CustomTextField(
              //   labelText: "Password",
              //   hintText: "•••••••••",
              //   keyboardType: TextInputType.visiblePassword,
              //   controller: passwordController,
              //   isPassword: true,
              //   isObscure: isObscure,
              //   rightIcon: IconButton(
              //     icon: Icon(
              //       isObscure ? Icons.visibility : Icons.visibility_off,
              //       size: 20,
              //     ),
              //     color: subtitleTextColor,
              //     onPressed: () {
              //       setState(() {
              //         isObscure = !isObscure;
              //       });
              //     },
              //   ),
              // ),

              const SizedBox(
                height: 25,
              ),
              PrimaryButton(
                isLoading: _isLoading,
                onPressed: handleLogin,
                child: Text(
                  "SEND EMAIL",
                  style: headingNormalTextStyle.copyWith(
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
