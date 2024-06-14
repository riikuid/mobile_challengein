import "dart:convert";

import "package:http/http.dart" as http;
import "package:mobile_challengein/model/user_model.dart";

class AuthService {
  final String baseUrl = "http://143.198.229.13:8000/api";

  Future<UserModel> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    var url = '$baseUrl/auth/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    });
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      return user;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<UserModel> authWithToken(String token) async {
    var url = '$baseUrl/auth/user-profile';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      return user;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    var url = '$baseUrl/auth/register';

    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({
      'name': fullName,
      'email': email,
      'password': password,
      'confirm_password': passwordConfirmation,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<UserModel> activateAccount({
    required String code,
    required String fcmToken,
  }) async {
    var url = '$baseUrl/auth/verifikasi-email';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'code': code,
      'fcm_token': fcmToken,
    });
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      return user;
    } else if (response.statusCode != 200) {
      throw jsonDecode(response.body)['messages'];
    } else {
      throw "Failed To Login";
    }
  }

  Future<void> logout({
    UserModel? user,
    required String token,
  }) async {
    var url = '$baseUrl/auth/logout';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await http.post(Uri.parse(url), headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      print('Success logout');
    } else {
      throw Exception('Failed to logout user.');
    }
  }

  Future<bool> reqCode({
    required String email,
    required bool isForgotPassword,
  }) async {
    var url = '$baseUrl/auth/kode${isForgotPassword ? '/password' : ''}';
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'email': email,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<String> reqCodePassword({required String email}) async {
    var url = '$baseUrl/auth/kode/pasword';
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'email': email,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['messages'];
    } else {
      throw Exception('Failed to request code.');
    }
  }

  Future<bool> checkCodePassword({
    required String code,
  }) async {
    var url = '$baseUrl/auth/verifikasi-password';
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'code': code,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }

  Future<bool> createNewPassword({
    required String code,
    required String password,
    required String confirmationPassword,
  }) async {
    var url = '$baseUrl/auth/ganti-password';
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'code': code,
      'password': password,
      'confirm_password': confirmationPassword,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw jsonDecode(response.body)['messages'];
    }
  }
}
