import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mobile_challengein/model/notification_model.dart';
import 'package:mobile_challengein/model/payout_model.dart';

class InboxService {
  final String baseUrl = "http://143.198.229.13:8000/api";

  Future<List<NotificationModel>> getNotificationHistory({
    required String token,
  }) async {
    var url = '$baseUrl/auth/user/notification';
    var headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    log(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<NotificationModel> notifications =
          data.map((item) => NotificationModel.fromJson(item)).toList();
      return notifications;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<List<PayoutModel>> getPayoutHistory({
    required String token,
  }) async {
    var url = '$baseUrl/auth/payout';
    var headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    log(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<PayoutModel> notifications =
          data.map((item) => PayoutModel.fromJson(item)).toList();
      return notifications;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }
}
