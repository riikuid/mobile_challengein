import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_challengein/pages/auth/activation_page.dart';
import 'package:mobile_challengein/pages/auth/sign_in_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';
import 'package:mobile_challengein/widget/primary_button.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isObscure = true;
  bool isObscure2 = true;
  bool _isLoading = false;
  TextEditingController fullNameController = TextEditingController(text: "");
  final FocusNode _fullNameFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController(text: "");
  final FocusNode _emailFocusNode = FocusNode();
  TextEditingController passwordControler = TextEditingController(text: "");
  final FocusNode _passwordFocusNode = FocusNode();
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String errorText = "Failed to register";

  Future<void> handleRegister() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    await authProvider
        .register(
      email: emailController.text,
      password: passwordControler.text,
      passwordConfirmation: confirmPasswordController.text,
      fullName: fullNameController.text,
      errorCallback: (e) => setState(
        () {
          errorText = e.toString();
        },
      ),
    )
        .then(
      (value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivationPage(
                email: emailController.text,
              ),
            ),
          );
        } else {
          ThrowSnackbar().showError(context, errorText);
        }
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(
                parent: NeverScrollableScrollPhysics()),
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
                    "Create an Account",
                    style: headingLargeTextStyle.copyWith(
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    "Let’s start your financial journey\nwith us!",
                    style: paragraphNormalTextStyle.copyWith(
                      height: 1.5,
                      fontWeight: regular,
                      color: subtitleTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomTextField(
                    labelText: "Full Name",
                    hintText: "e.g Agus Halim",
                    keyboardType: TextInputType.name,
                    controller: fullNameController,
                    textInputAction: TextInputAction.next,
                    focusNode: _fullNameFocusNode,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    labelText: "Email",
                    hintText: "example@mail.com",
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocusNode,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    labelText: "Password",
                    hintText: "•••••••••",
                    keyboardType: TextInputType.emailAddress,
                    controller: passwordControler,
                    isPassword: true,
                    isObscure: isObscure,
                    enableTooltip: true,
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
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    focusNode: _confirmPasswordFocusNode,
                    labelText: "Confirm Password",
                    hintText: "•••••••••",
                    keyboardType: TextInputType.emailAddress,
                    controller: confirmPasswordController,
                    isPassword: true,
                    isObscure: isObscure2,
                    rightIcon: IconButton(
                      icon: Icon(
                        isObscure2 ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                      color: subtitleTextColor,
                      onPressed: () {
                        setState(() {
                          isObscure2 = !isObscure2;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  PrimaryButton(
                      isLoading: _isLoading,
                      onPressed: handleRegister,
                      child: Text(
                        "SIGN UP",
                        style: headingNormalTextStyle.copyWith(
                          color: whiteColor,
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
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
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign In",
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
        ),
      ),
    );
  }
}
