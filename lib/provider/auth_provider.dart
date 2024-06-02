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
      log("LOG TOKEN");
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

  Future<bool> reqCode({
    required String email,
    bool? isForgotPassword,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      await AuthService().reqCode(
        isForgotPassword: isForgotPassword ?? false,
        email: email,
      );
      return true;
      // return true;
    } catch (e) {
      errorCallback?.call(e);
      print(e);
      return false;
    }
  }

  Future<bool> logout({
    UserModel? user,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      log(" TOKEN LOGOUT ${await tokenRepository.getToken()}");
      await AuthService().logout(
        user: user,
        token: (await tokenRepository.getToken())!,
      );
      _user = null;
      tokenRepository.clearToken();
      return true;
    } catch (e) {
      errorCallback?.call(e);
      print(e);
      return false;
    }
  }

  Future<bool> checkCodeForgotPassword({
    required String code,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      await AuthService().checkCodePassword(
        code: code,
      );
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (e) {
      errorCallback?.call(e);
      return false;
    }
  }

  Future<bool> createNewPassword({
    required String code,
    required String password,
    required String confirmationPassword,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      await AuthService().createNewPassword(
        code: code,
        password: password,
        confirmationPassword: confirmationPassword,
      );
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (e) {
      errorCallback?.call(e);
      return false;
    }
  }
}
