import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/model/user_saving.dart';
import 'package:mobile_challengein/service/saving_service.dart';

class SavingProvider with ChangeNotifier {
  List<SavingModel> _savings = [];
  List<SavingModel> get savings => _savings;

  UserSaving? _userSaving;
  UserSaving? get userSaving => _userSaving;

  Future<bool> getSavings(
    String token,
    void Function(dynamic)? errorCallback,
    String idSaving,
  ) async {
    try {
      List<SavingModel> savings =
          await SavingService().getSavings(token: token);
      _savings = savings;
      getUserSaving(token, (p0) {});
      log("INI ISI DARI GET SAVINGS");
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      getUserSaving(token, (p0) {});
      log('qqqqqq $error');
      errorCallback?.call(error);
      return false;
    }
  }

  Future<bool> getUserSaving(
    String token,
    void Function(dynamic)? errorCallback,
  ) async {
    try {
      UserSaving result = await SavingService().getUserSavings(token: token);
      _userSaving = result;
      notifyListeners();
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      log('qqqqqq $error');
      errorCallback?.call(error);
      rethrow;
    }
  }

  Future<SavingModel> createSaving(
    String token,
    SavingRequest request,
    String pathImage,
    void Function(dynamic)? errorCallback,
  ) async {
    try {
      SavingModel saving =
          await SavingService().createSaving(token, request, pathImage);
      _savings.add(saving);
      getUserSaving(token, (p0) {});
      return saving;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      errorCallback?.call(error);
      rethrow;
    }
  }

  Future<bool> updateSavingsRecord({
    required String amount,
    required String updateType,
    required String idSaving,
    required String token,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      SavingModel newSaving = await SavingService().updateSavingRecordsAmount(
        amount: amount,
        updateType: updateType,
        idSaving: idSaving,
        token: token,
      );

      _savings = _savings.map((saving) {
        if (saving.id == newSaving.id) {
          return newSaving;
        } else {
          return saving;
        }
      }).toList();
      notifyListeners();
      getUserSaving(token, (p0) {});
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      // print("tes");
      return false;
    } catch (error) {
      errorCallback?.call(error);
      // print(error);
      return false;
    }
  }

  Future<bool> deleteSaving({
    required String idSaving,
    required String token,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      await SavingService().deleteSaving(
        idSaving: idSaving,
        token: token,
      );

      _savings.removeWhere((saving) => saving.id == idSaving);

      notifyListeners();
      getUserSaving(token, (p0) {});
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      // print("tes");
      return false;
    } catch (error) {
      errorCallback?.call(error);
      // print(error);
      return false;
    }
  }
}
