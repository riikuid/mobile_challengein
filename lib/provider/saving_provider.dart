import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/history_model.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/model/user_saving.dart';
import 'package:mobile_challengein/provider/history_provider.dart';
import 'package:mobile_challengein/service/history_service.dart';
import 'package:mobile_challengein/service/saving_service.dart';

class SavingProvider with ChangeNotifier {
  List<SavingModel> _savings = [];
  List<SavingModel> get savings => _savings;

  UserSaving? _userSaving;
  UserSaving? get userSaving => _userSaving;

  List<HistoryModel> _savingHistories = [];
  List<HistoryModel> get savingHistories => _savingHistories;

  bool isOnTrx = false;

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
    } on PathNotFoundException {
      errorCallback?.call("Image can't be empty ");
      rethrow;
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

      await refreshGetHistory(
        token: token,
        idSaving: idSaving,
      );

      isOnTrx = true;

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

  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;

  Future getHistory({
    required String token,
    required String idSaving,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      List<HistoryModel> result = await HistoryService().getHistory(
        token: token,
        limit: _limit,
        page: _page,
        idSavings: idSaving,
      );

      if (result.length < _limit) {
        hasMore = false;
      }
      _savingHistories.addAll(result);

      _page++;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) log(error.toString());
      errorCallback?.call(error);
    }
  }

  Future refreshGetHistory(
      {required String token, required String idSaving}) async {
    _page = 1;
    _savingHistories = [];
    hasMore = true;

    await getHistory(token: token, idSaving: idSaving);
    notifyListeners();
  }

  void onDoneTrx() {
    isOnTrx = false;
  }
}
