// To parse this JSON data, do
//
//     final bookingsResponse = bookingsResponseFromJson(jsonString);

import 'dart:convert';

BookingsResponse bookingsResponseFromJson(String str) => BookingsResponse.fromJson(json.decode(str));

String bookingsResponseToJson(BookingsResponse data) => json.encode(data.toJson());

class BookingsResponse {
  final List<Datum>? data;
  final bool? success;
  final String? message;
  final int? statusCode;
  final int? count;

  BookingsResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.count,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) => BookingsResponse(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    success: json["success"],
    message: json["message"],
    statusCode: json["statusCode"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "message": message,
    "statusCode": statusCode,
    "count": count,
  };
}

class Datum {
  final BookingSearchResult? bookingSearchResult;
  final VehicleInforSearchResult? vehicleInforSearchResult;
  final ParkingSearchResult? parkingSearchResult;
  final ParkingSlotSearchResult? parkingSlotSearchResult;

  Datum({
    this.bookingSearchResult,
    this.vehicleInforSearchResult,
    this.parkingSearchResult,
    this.parkingSlotSearchResult,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    bookingSearchResult: json["bookingSearchResult"] == null ? null : BookingSearchResult.fromJson(json["bookingSearchResult"]),
    vehicleInforSearchResult: json["vehicleInforSearchResult"] == null ? null : VehicleInforSearchResult.fromJson(json["vehicleInforSearchResult"]),
    parkingSearchResult: json["parkingSearchResult"] == null ? null : ParkingSearchResult.fromJson(json["parkingSearchResult"]),
    parkingSlotSearchResult: json["parkingSlotSearchResult"] == null ? null : ParkingSlotSearchResult.fromJson(json["parkingSlotSearchResult"]),
  );

  Map<String, dynamic> toJson() => {
    "bookingSearchResult": bookingSearchResult?.toJson(),
    "vehicleInforSearchResult": vehicleInforSearchResult?.toJson(),
    "parkingSearchResult": parkingSearchResult?.toJson(),
    "parkingSlotSearchResult": parkingSlotSearchResult?.toJson(),
  };
}

class BookingSearchResult {
  final int? bookingId;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? dateBook;
  final String? status;

  BookingSearchResult({
    this.bookingId,
    this.startTime,
    this.endTime,
    this.dateBook,
    this.status,
  });

  factory BookingSearchResult.fromJson(Map<String, dynamic> json) => BookingSearchResult(
    bookingId: json["bookingId"],
    startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
    endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    dateBook: json["dateBook"] == null ? null : DateTime.parse(json["dateBook"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "bookingId": bookingId,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "dateBook": dateBook?.toIso8601String(),
    "status": status,
  };
}

class ParkingSearchResult {
  final int? parkingId;
  final String? name;
  final String? address;

  ParkingSearchResult({
    this.parkingId,
    this.name,
    this.address,
  });

  factory ParkingSearchResult.fromJson(Map<String, dynamic> json) => ParkingSearchResult(
    parkingId: json["parkingId"],
    name: json["name"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "parkingId": parkingId,
    "name": name,
    "address": address,
  };
}

class ParkingSlotSearchResult {
  final int? parkingSlotId;
  final String? name;
  final int? rowIndex;
  final int? columnIndex;
  final String? floorName;

  ParkingSlotSearchResult({
    this.parkingSlotId,
    this.name,
    this.rowIndex,
    this.columnIndex,
    this.floorName,
  });

  factory ParkingSlotSearchResult.fromJson(Map<String, dynamic> json) => ParkingSlotSearchResult(
    parkingSlotId: json["parkingSlotId"],
    name: json["name"],
    rowIndex: json["rowIndex"],
    columnIndex: json["columnIndex"],
    floorName: json["floorName"],
  );

  Map<String, dynamic> toJson() => {
    "parkingSlotId": parkingSlotId,
    "name": name,
    "rowIndex": rowIndex,
    "columnIndex": columnIndex,
    "floorName": floorName,
  };
}

class VehicleInforSearchResult {
  final int? vehicleInforId;
  final String? licensePlate;
  final String? vehicleName;
  final int? trafficId;
  final String? trafficName;

  VehicleInforSearchResult({
    this.vehicleInforId,
    this.licensePlate,
    this.vehicleName,
    this.trafficId,
    this.trafficName,
  });

  factory VehicleInforSearchResult.fromJson(Map<String, dynamic> json) => VehicleInforSearchResult(
    vehicleInforId: json["vehicleInforId"],
    licensePlate: json["licensePlate"],
    vehicleName: json["vehicleName"],
    trafficId: json["trafficId"],
    trafficName: json["trafficName"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleInforId": vehicleInforId,
    "licensePlate": licensePlate,
    "vehicleName": vehicleName,
    "trafficId": trafficId,
    "trafficName": trafficName,
  };
}
