import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String id;
  final String role;
  final String name;
  final String email;
  final String refreshToken;
  final dynamic fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.refreshToken,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? role,
    String? name,
    String? email,
    String? refreshToken,
    dynamic fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        role: role ?? this.role,
        name: name ?? this.name,
        email: email ?? this.email,
        refreshToken: refreshToken ?? this.refreshToken,
        fcmToken: fcmToken ?? this.fcmToken,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        role: json["role"],
        name: json["name"],
        email: json["email"],
        refreshToken: json["refresh_token"],
        fcmToken: json["fcm_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
        "email": email,
        "refresh_token": refreshToken,
        "fcm_token": fcmToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
