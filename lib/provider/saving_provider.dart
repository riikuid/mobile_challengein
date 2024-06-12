import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobile_challengein/common/token_repository.dart';
import 'package:mobile_challengein/model/bank_model.dart';
import 'package:mobile_challengein/model/history_model.dart';
import 'package:mobile_challengein/model/payout_account_model.dart';
import 'package:mobile_challengein/model/payout_model.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/model/topup_model.dart';
import 'package:mobile_challengein/model/user_saving.dart';
import 'package:mobile_challengein/service/history_service.dart';
import 'package:mobile_challengein/service/saving_service.dart';

class SavingProvider with ChangeNotifier {
  final tokenRepository = TokenRepository();

  List<SavingModel> _savings = [];
  List<SavingModel> get savings => _savings;

  UserSaving? _userSaving;
  UserSaving? get userSaving => _userSaving;

  PayoutAccountModel? _payoutAccountModel;
  PayoutAccountModel? get payoutAccountModel => _payoutAccountModel;

  PayoutModel? _payoutModel;
  PayoutModel? get payoutModel => _payoutModel;

  List<HistoryModel> _savingHistories = [];
  List<HistoryModel> get savingHistories => _savingHistories;

  List<BankModel> _listBank = [];
  List<BankModel> get listBank => _listBank;

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
      await checkQrExpired();
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
      String text = error.toString();
      if (error is List) {
        text = error.join(",");
      }
      errorCallback?.call(error);
      throw text;
    }
  }

  Future<SavingModel> editSaving({
    required String token,
    required SavingRequest request,
    String? pathImage,
    required String idSaving,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      SavingModel newSaving = await SavingService().editSaving(
        token: token,
        request: request,
        idSaving: idSaving,
        pathImage: pathImage,
      );

      _savings = _savings.map((saving) {
        if (saving.id == newSaving.id) {
          return newSaving;
        } else {
          return saving;
        }
      }).toList();

      await refreshGetHistory(
        idSaving: idSaving,
      );

      getUserSaving(token, (p0) {});
      return newSaving;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
    } on PathNotFoundException {
      errorCallback?.call("Image can't be empty ");
      throw "Image can't be empty";
    } catch (error) {
      errorCallback?.call(error);
      rethrow;
    }
  }

  Future<bool> updateSavingsRecord({
    required String amount,
    required String updateType,
    required String idSaving,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      SavingModel newSaving = await SavingService().updateSavingRecordsAmount(
        amount: amount,
        updateType: updateType,
        idSaving: idSaving,
        token: (await tokenRepository.getToken())!,
      );

      _savings = _savings.map((saving) {
        if (saving.id == newSaving.id) {
          return newSaving;
        } else {
          return saving;
        }
      }).toList();

      await refreshGetHistory(
        idSaving: idSaving,
      );

      isOnTrx = true;

      notifyListeners();
      getUserSaving((await tokenRepository.getToken())!, (p0) {});
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");

      return false;
    } catch (error) {
      errorCallback?.call(error);
      // print(error);
      return false;
    }
  }

  Future<bool> topUpSavingWallet({
    required String amount,
    required String idSaving,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      log("REQ RQ BARU");
      TopUpModel qrCode = await SavingService().topUpSavingWallet(
        amount: amount,
        idSaving: idSaving,
        token: (await tokenRepository.getToken())!,
      );
      log("DONE REQ");

      await refreshGetHistory(
        idSaving: idSaving,
      );
      isOnTrx = true;

      _topUpModel = qrCode;

      notifyListeners();

      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (error) {
      log("Error di topup: ${error.toString()}");
      errorCallback?.call(error);
      return false;
    }
  }

  TopUpModel? _topUpModel;
  TopUpModel? get topUpModel => _topUpModel;

  Future<bool> checkQrExpired({
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      TopUpModel? qrCode = await SavingService().checkQrExpired(
        token: (await tokenRepository.getToken())!,
      );

      log("ADA QR LAMA GA: ${qrCode != null}");

      _topUpModel = qrCode;

      isOnTrx = true;
      await refreshGetHistory(
        idSaving: qrCode!.idSavings!,
      );
      notifyListeners();
      log("ADA LAMA");
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (error) {
      _topUpModel = null;
      log("ERROR CEK: ${error.toString()}");
      errorCallback?.call(error);
      return false;
    }
  }

  Future<bool> updateStatusReminder({
    required SavingModel saving,
    required bool changeTo,
    // required String token,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      saving.copyWith(
        isReminder: changeTo,
      );

      log(saving.toString());

      SavingModel newSaving = await SavingService().updateStatusReminder(
        idSaving: saving,
        token: (await tokenRepository.getToken())!,
      );

      _savings = _savings.map((saving) {
        if (saving.id == newSaving.id) {
          return newSaving;
        } else {
          return saving;
        }
      }).toList();

      notifyListeners();
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
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
        statusTrx: "",
        typeTrx: "",
        startDate: "",
        endDate: "",
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

  Future refreshGetHistory({required String idSaving}) async {
    log("UPDATE LATEST HISTORY");
    _page = 1;
    _savingHistories = [];
    hasMore = true;

    await getHistory(
        token: (await tokenRepository.getToken())!, idSaving: idSaving);
    notifyListeners();
  }

  void onDoneTrx() {
    isOnTrx = false;
  }

  Future<bool> getListBank({
    required String type,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      List<BankModel> result = await SavingService().getListBank(
        token: (await tokenRepository.getToken())!,
        type: type,
      );
      _listBank = result;
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      log('error get bank/ewallet list: $error');
      errorCallback?.call(error);
      return false;
    }
  }

  Future<bool> checkAccountPayout({
    required String type,
    required String accountNumber,
    required BankModel bank,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      PayoutAccountModel result = await SavingService().checkPayoutAccoung(
        token: (await tokenRepository.getToken())!,
        type: type,
        bank: bank,
        numberAccount: accountNumber,
      );

      _payoutAccountModel = result;
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      log('error get bank/ewallet list: $error');
      errorCallback?.call(error);
      return false;
    }
  }

  Future<bool> createPayout({
    required PayoutAccountModel account,
    required int amount,
    required String idSaving,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      log("Masuk Create Payout");
      PayoutModel result = await SavingService().createPayout(
        payoutAccount: account,
        amount: amount,
        idSaving: idSaving,
        token: (await tokenRepository.getToken())!,
      );
      log("DONE CREATE PAYOUT");

      await refreshGetHistory(
        idSaving: idSaving,
      );

      isOnTrx = true;

      _payoutModel = result;

      notifyListeners();

      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (error) {
      log("Error di topup: ${error.toString()}");
      errorCallback?.call(error);
      return false;
    }
  }
}
