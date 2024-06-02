import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/pages/auth/activation_page.dart';
import 'package:mobile_challengein/pages/auth/forgot_password_page.dart';
import 'package:mobile_challengein/pages/auth/sign_up_page.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';

import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String errorText = "Failed To Login";
  bool isObscure = true;
  bool _isLoading = false;

  Future<void> handleLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    final fcmToken = await messaging.getToken();

    setState(() {
      _isLoading = true;
    });
    print("FCM TOKEN $fcmToken");
    await authProvider
        .login(
      email: emailController.text,
      password: passwordController.text,
      fcmToken: fcmToken!,
      errorCallback: (e) => setState(
        () {
          errorText = e.toString();
        },
      ),
    )
        .then(
      (value) {
        if (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
            (route) => false,
          );
        } else {
          if (errorText == "Account not yet active. Please check your email!") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivationPage(
                  email: emailController.text,
                ),
              ),
            );
          }
          ThrowSnackbar().showError(context, errorText);
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
    passwordController = TextEditingController(text: "");
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
                "Welcome Back",
                style: headingLargeTextStyle.copyWith(
                  fontWeight: bold,
                ),
              ),
              Text(
                "Sign In to your account",
                style: paragraphNormalTextStyle.copyWith(
                  height: 2,
                  fontWeight: regular,
                  color: subtitleTextColor,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextField(
                textInputAction: TextInputAction.next,
                labelText: "Email Address",
                hintText: "example@mail.com",
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                labelText: "Password",
                hintText: "•••••••••",
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                isPassword: true,
                isObscure: isObscure,
                rightIcon: IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                  ),
                  color: subtitleTextColor,
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: labelLargeTextStyle.copyWith(
                      height: 4,
                      color: subtitleTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              PrimaryButton(
                isLoading: _isLoading,
                onPressed: handleLogin,
                child: Text(
                  "SEND CODE",
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
                    "Don't have an account?",
                    style: paragraphNormalTextStyle.copyWith(
                      color: subtitleTextColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: paragraphNormalTextStyle.copyWith(
                        fontWeight: semibold,
                        color: primaryColor500,
                        decoration: TextDecoration.underline,
                      ),
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
