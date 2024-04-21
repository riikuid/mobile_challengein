import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/service/saving_service.dart';

class SavingProvider with ChangeNotifier {
  List<SavingModel> _savings = [];
  List<SavingModel> get savings => _savings;

  Future<void> getSavings(
    String token,
  ) async {
    try {
      List<SavingModel> savings = await SavingService().getAllSavings(token);
      _savings = savings;
    } catch (e) {
      print(e);
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
}
