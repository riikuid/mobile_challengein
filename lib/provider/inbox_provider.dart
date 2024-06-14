import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_challengein/common/token_repository.dart';
import 'package:mobile_challengein/model/notification_model.dart';
import 'package:mobile_challengein/model/payout_model.dart';
import 'package:mobile_challengein/service/inbox_service.dart';

class InboxProvider with ChangeNotifier {
  final TokenRepository tokenRepository = TokenRepository();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  List<PayoutModel> _payoutHistory = [];
  List<PayoutModel> get payoutHistory => _payoutHistory;

  Future<bool> getNotificationHistory(
    void Function(dynamic)? errorCallback,
  ) async {
    try {
      List<NotificationModel> result =
          await InboxService().getNotificationHistory(
        token: (await tokenRepository.getToken())!,
      );
      _notifications = result;
      log("SUKSES GET NOTIFICATIONS");
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      log('qqqqqq $error');
      errorCallback?.call(error);
      return false;
    }
  }

  Future<bool> getPayoutHistory(
    void Function(dynamic)? errorCallback,
  ) async {
    try {
      List<PayoutModel> result = await InboxService().getPayoutHistory(
        token: (await tokenRepository.getToken())!,
      );
      _payoutHistory = result;
      log("SUKSES GET PAYOUTS");
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      rethrow;
      // throw "No Internet Connection";
    } catch (error) {
      log('qqqqqq PEYOUT $error');
      errorCallback?.call(error);
      return false;
    }
  }
}
