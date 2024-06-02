import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/token_repository.dart';
import 'package:mobile_challengein/pages/auth/sign_in_page.dart';
import 'package:mobile_challengein/pages/dashboard/dashboard.dart';
import 'package:mobile_challengein/pages/dashboard/home_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/widget/throw_snackbar.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final tokenRepository = TokenRepository();
  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  Future authCheck() async {
    log("MASUK AUTH");
    final token =
        await tokenRepository.getToken(); // Ambil token dari Shared Preferences
    if (token != null) {
      log("TOKEN ONOK");
      final success = await authProvider.authWithToken(errorCallback: (error) {
        // Tampilkan pesan error jika terjadi kesalahan
        // ThrowSnackbar().showError(context, error);
      });
      if (success) {
        log("SUKSES BOLO");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ));
      } else {
        log("GAISOK ");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInPage(),
            ));
      }
    } else {
      log("NuLL ");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInPage(),
          ));
    }
  }

  @override
  void initState() {
    // authCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authCheck();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
