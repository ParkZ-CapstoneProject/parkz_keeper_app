// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  final ProfileData? data;
  final bool? success;
  final String? message;
  final int? statusCode;
  final int? count;

  ProfileResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.count,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
    success: json["success"],
    message: json["message"],
    statusCode: json["statusCode"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "message": message,
    "statusCode": statusCode,
    "count": count,
  };
}

class ProfileData {
  final int? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool? isActive;
  final String? roleName;
  final int? parkingId;
  final String? parkingName;

  ProfileData({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.dateOfBirth,
    this.gender,
    this.isActive,
    this.roleName,
    this.parkingId,
    this.parkingName,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    userId: json["userId"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    avatar: json["avatar"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    gender: json["gender"],
    isActive: json["isActive"],
    roleName: json["roleName"],
    parkingId: json["parkingId"],
    parkingName: json["parkingName"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "gender": gender,
    "isActive": isActive,
    "roleName": roleName,
    "parkingId": parkingId,
    "parkingName": parkingName,
  };
}
