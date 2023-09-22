// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) => DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) => json.encode(data.toJson());

class DashboardResponse {
  final Data? data;
  final bool? success;
  final String? message;
  final int? statusCode;
  final int? count;

  DashboardResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.count,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
  final int? numberOfOrders;
  final double? totalOfRevenue;
  final int? numberOfOrdersInCurrentDay;
  final int? waitingOrder;

  Data({
    this.numberOfOrders,
    this.totalOfRevenue,
    this.numberOfOrdersInCurrentDay,
    this.waitingOrder,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    numberOfOrders: json["numberOfOrders"],
    totalOfRevenue: json["totalOfRevenue"]?.toDouble(),
    numberOfOrdersInCurrentDay: json["numberOfOrdersInCurrentDay"],
    waitingOrder: json["waitingOrder"],
  );

  Map<String, dynamic> toJson() => {
    "numberOfOrders": numberOfOrders,
    "totalOfRevenue": totalOfRevenue,
    "numberOfOrdersInCurrentDay": numberOfOrdersInCurrentDay,
    "waitingOrder": waitingOrder,
  };
}
