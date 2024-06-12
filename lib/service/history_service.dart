import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mobile_challengein/model/history_model.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  final String baseUrl = "http://143.198.229.13:8000/api";

  Future<List<HistoryModel>> getHistory({
    required String token,
    required int page,
    required int limit,
    required String typeTrx,
    required String statusTrx,
    required String startDate,
    required String endDate,
    String idSavings = '',
  }) async {
    var url = '$baseUrl/auth/history/savings?id=$idSavings';
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var body = {
      'limit': limit.toString(),
      'page': page.toString(),
      'type_trx': typeTrx,
      'status_trx': statusTrx,
      "start_date": startDate,
      "end_date": endDate,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    log(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<HistoryModel> histories =
          data.map((item) => HistoryModel.fromJson(item)).toList();
      return histories;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }
}
