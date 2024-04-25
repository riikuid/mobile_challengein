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

    final response = await http.get(
      Uri.parse(url),
      headers: body,
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

  Future<SavingModel> createSaving(
      String token, SavingRequest request, String pathImage) async {
    var url = '$baseUrl/auth/savings';
    var requestMultipart = http.MultipartRequest('POST', Uri.parse(url));

    var headers = {
      'Authorization': 'Bearer $token',
    };

    requestMultipart.fields.addAll(request.toJson());

    // Baca file gambar sebagai MultipartFile dan tambahkan ke dalam permintaan multipart
    var imageFile = await http.MultipartFile.fromPath('path_image', pathImage);
    requestMultipart.files.add(imageFile);

    // Set header
    requestMultipart.headers.addAll(headers);

    // Kirim permintaan
    var streamedResponse = await requestMultipart.send();

    // Terima respons
    var response = await http.Response.fromStream(streamedResponse);

    log(response.body);

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body)['data'];
      SavingModel saving = SavingModel.fromJson(data);
      return saving;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<SavingModel> updateSavingRecordsAmount({
    required String token,
    required String idSaving,
    required String amount,
    required String updateType,
  }) async {
    var url = '$baseUrl/auth/savings/$updateType/$idSaving';
    var headers = {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = {
      'amount': amount,
    };

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      SavingModel saving = SavingModel.fromJson(data);
      return saving;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<SavingModel> deleteSavings({
    required String token,
    required String idSaving,
    required String amount,
    required String updateType,
  }) async {
    var url = '$baseUrl/auth/savings/$updateType/$idSaving';
    var headers = {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = {
      'amount': amount,
    };

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      SavingModel saving = SavingModel.fromJson(data);
      return saving;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }
}
