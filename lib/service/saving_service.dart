import 'dart:convert';
import 'dart:developer';

import 'package:mobile_challengein/model/bank_model.dart';
import 'package:mobile_challengein/model/payout_account_model.dart';
import 'package:mobile_challengein/model/payout_model.dart';
import 'package:mobile_challengein/model/request/saving_request.dart';
import 'package:mobile_challengein/model/savings_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_challengein/model/topup_model.dart';
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

  Future<SavingModel> editSaving({
    required String token,
    required SavingRequest request,
    String? pathImage,
    required String idSaving,
  }) async {
    var url = '$baseUrl/auth/savings/$idSaving';
    var requestMultipart = http.MultipartRequest('POST', Uri.parse(url));

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var response;

    if (pathImage!.isNotEmpty) {
      log("MASUK MULTIPART");
      requestMultipart.fields.addAll(request.toJson());
      // Baca file gambar sebagai MultipartFile dan tambahkan ke dalam permintaan multipart
      var imageFile = await http.MultipartFile.fromPath(
        'path_image',
        pathImage,
      );
      requestMultipart.files.add(imageFile);

      // Set header
      requestMultipart.headers.addAll(headers);

      // Kirim permintaan
      var streamedResponse = await requestMultipart.send();

      // Terima respons
      response = await http.Response.fromStream(streamedResponse);
    } else {
      log("MASUK POST");
      log(request.toJson().toString());
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: request.toJson(),
      );
    }

    log(response.body);

    if (response.statusCode == 200) {
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

  Future<TopUpModel> topUpSavingWallet({
    required String token,
    required String idSaving,
    required String amount,
  }) async {
    var url = '$baseUrl/auth/savings/wallet/$idSaving';
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var body = {
      'amount': amount,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      TopUpModel result = TopUpModel.fromJson(data);
      return result;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<TopUpModel?> checkQrExpired({
    required String token,
  }) async {
    var url = '$baseUrl/auth/check-qrcode/';
    var headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    log("isi nya ${response.body}");

    // log("ISI DARI TOPUP AMOUNT: ${jsonDecode(response.body)['data']['topup_amount'].toString()}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      TopUpModel result = TopUpModel.fromJson(data);
      return result;
    } else if (response.statusCode == 407) {
      throw jsonDecode(response.statusCode.toString());
    } else if (response.statusCode == 404) {
      throw jsonDecode(response.statusCode.toString());
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<SavingModel> updateStatusReminder({
    required String token,
    required SavingModel idSaving,
  }) async {
    var url = '$baseUrl/auth/setting/reminder/';
    var headers = {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = {
      'day_reminder': idSaving.dayReminder,
      'time_reminder': idSaving.timeReminder,
      'id': idSaving.id,
      'is_reminder': idSaving.isReminder ? 1 : 0,
    };
    log(body.toString());

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    log(response.body);

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

  Future<List<BankModel>> getListBank({
    required String token,
    required String type,
  }) async {
    var url = '$baseUrl/auth/list/$type';
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
      List data = jsonDecode(response.body)['data'];
      List<BankModel> result =
          data.map((item) => BankModel.fromJson(item)).toList();
      return result;
    } else {
      throw Exception('Failed to get list $type.');
    }
  }

  Future<PayoutAccountModel> checkPayoutAccoung({
    required BankModel bank,
    required String type,
    required String numberAccount,
    required String token,
  }) async {
    var url =
        '$baseUrl/auth/check-$type?bank_code=${bank.kodeBank}&account_number=$numberAccount';
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
      PayoutAccountModel result = PayoutAccountModel.fromJson(data);
      return result;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<PayoutModel> createPayout({
    required String token,
    required PayoutAccountModel payoutAccount,
    required int amount,
    required String idSaving,
  }) async {
    var url = '$baseUrl/auth/payout';
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var body = {
      'amount': amount,
      "id_savings": idSaving,
      "norek": payoutAccount.accountnumber,
      "name_rekening": payoutAccount.bankname,
      "amount_money": amount
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body)['data'];
      PayoutModel result = PayoutModel.fromJson(data);
      return result;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }
}
