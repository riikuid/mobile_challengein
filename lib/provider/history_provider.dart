import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mobile_challengein/common/token_repository.dart';
import 'package:mobile_challengein/model/history_model.dart';
import 'package:mobile_challengein/service/history_service.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryModel> _histories = [];
  List<HistoryModel> get histories => _histories;
  final TokenRepository tokenRepository = TokenRepository();

  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;

  bool serviceLoading = false;

  final HistoryService _historyService = HistoryService();

  Future getHistory({
    required String typeTrx,
    required String statusTrx,
    required String startDate,
    required String endDate,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      typeTrx = typeTrx.toLowerCase();
      statusTrx = statusTrx.toLowerCase();
      List<HistoryModel> result = await _historyService.getHistory(
        startDate: startDate,
        endDate: endDate,
        typeTrx: typeTrx == "all" ? "" : typeTrx,
        statusTrx: statusTrx == "all" ? "" : statusTrx,
        token: (await tokenRepository.getToken())!,
        limit: _limit,
        page: _page,
      );

      if (result.length < _limit) {
        hasMore = false;
      }

      for (var item in result) {
        _histories.add(item);
      }

      _page++;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) log(error.toString());
      errorCallback?.call(error);
    }
  }

  Future refreshGetHistory({
    required String typeTrx,
    required String statusTrx,
    required String startDate,
    required String endDate,
  }) async {
    _page = 1;
    _histories = [];
    hasMore = true;
    // notifyListeners();

    await getHistory(
      startDate: startDate,
      endDate: endDate,
      typeTrx: typeTrx,
      statusTrx: statusTrx,
    );
    serviceLoading = false;
    notifyListeners();
  }
}
