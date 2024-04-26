import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mobile_challengein/model/history_model.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  final String baseUrl = "http://143.198.229.13:8000/api";

  Future<List<HistoryModel>> getListHistory(
      String token, HistoryModel? history) async {
    var url = '$baseUrl/auth/history/savings';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = {
      'limit': '10',
      'page': "1",
    };

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: body,
    );

    print(response.body);

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
