import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/token_repository.dart';
import 'package:mobile_challengein/model/user_model.dart';
import 'package:mobile_challengein/pages/dashboard/home_page.dart';
import 'package:mobile_challengein/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final tokenRepository = TokenRepository();
  UserModel? _user;
  UserModel get user => _user!;

  Future<bool> login({
    required String email,
    required String password,
    required String fcmToken,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );
      _user = user;
      tokenRepository.putToken(user.refreshToken);
      notifyListeners();
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (e) {
      errorCallback?.call(e);
      // print(e.toString());
      return false;
    }
  }

  Future<bool> authWithToken({
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      log("COKK");
      UserModel user = await AuthService()
          .authWithToken((await tokenRepository.getToken())!);
      _user = user;
      tokenRepository.putToken(user.refreshToken);
      notifyListeners();
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (e) {
      errorCallback?.call(e);
      // print(e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      bool registerStatus = await AuthService().register(
        fullName: fullName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      return registerStatus;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (e) {
      errorCallback?.call(e);
      // print(e.toString());
      return false;
    }
  }

  Future<bool> activateAccount({
    required String code,
    required String fcmToken,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      UserModel user = await AuthService().activateAccount(
        code: code,
        fcmToken: fcmToken,
      );
      _user = user;
      tokenRepository.putToken(user.refreshToken);
      notifyListeners();
      return true;
    } catch (e) {
      errorCallback?.call(e);
      return false;
    }
  }

  Future<void> reqCode({
    required String email,
  }) async {
    try {
      await AuthService().reqCode(
        email: email,
      );
      // return true;
    } catch (e) {
      print(e);
      // return false;
    }
  }

  Future<void> checkAuthenticationStatus(BuildContext context) async {
    bool isLoggedIn = await tokenRepository.getToken() != null;
    if (isLoggedIn) {
      try {
        authWithToken();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        print(e.toString());
      }
      // Jika pengguna sudah login, arahkan ke HomePage
    }
  }
}
