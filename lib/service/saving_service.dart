import 'dart:convert';
import 'dart:developer';

import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challengein/model/user_saving.dart';

class SavingService {
  final String baseUrl = "http://143.198.229.13:8000/api";

  Future<UserSaving> getUserSavings({
    required String token,
  }) async {
    var url = '$baseUrl/auth/record/savings';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserSaving userSaving = UserSaving.fromJson(data);
      return userSaving;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<List<SavingModel>> getSavings(
      {required String token, savingId}) async {
    var url = '$baseUrl/auth/all/savings';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<SavingModel> savings =
          data.map((item) => SavingModel.fromJson(item)).toList();
      return savings;
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

  Future<bool> deleteSaving({
    required String token,
    required String idSaving,
  }) async {
    var url = '$baseUrl/auth/savings/$idSaving';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];

      return true;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }
}
