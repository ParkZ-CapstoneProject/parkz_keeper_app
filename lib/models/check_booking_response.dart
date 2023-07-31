// To parse this JSON data, do
//
//     final checkBooking = checkBookingFromJson(jsonString);

import 'dart:convert';

CheckBooking checkBookingFromJson(String str) => CheckBooking.fromJson(json.decode(str));

String checkBookingToJson(CheckBooking data) => json.encode(data.toJson());

class CheckBooking {
  final Data? data;
  final bool? success;
  final String? message;
  final int? statusCode;
  final int? count;

  CheckBooking({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.count,
  });

  factory CheckBooking.fromJson(Map<String, dynamic> json) => CheckBooking(
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
  final int? parkingId;
  final Booking? booking;

  Data({
    this.parkingId,
    this.booking,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    parkingId: json["parkingId"],
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "parkingId": parkingId,
    "booking": booking?.toJson(),
  };
}

class Booking {
  final int? bookingId;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;
  final DateTime? dateBook;
  final String? status;
  final String? guestName;
  final String? guestPhone;
  final double? totalPrice;
  final String? qrImage;
  final double? unPaidMoney;
  final VehicleInfor? vehicleInfor;
  final List<Transaction>? transactions;

  Booking({
    this.bookingId,
    this.startTime,
    this.endTime,
    this.checkinTime,
    this.checkoutTime,
    this.dateBook,
    this.status,
    this.guestName,
    this.guestPhone,
    this.totalPrice,
    this.qrImage,
    this.unPaidMoney,
    this.vehicleInfor,
    this.transactions,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    bookingId: json["bookingId"],
    startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
    endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    checkinTime: json["checkinTime"] == null ? null : DateTime.parse(json["checkinTime"]),
    checkoutTime: json["checkoutTime"] == null ? null : DateTime.parse(json["checkoutTime"]),
    dateBook: json["dateBook"] == null ? null : DateTime.parse(json["dateBook"]),
    status: json["status"],
    guestName: json["guestName"],
    guestPhone: json["guestPhone"],
    totalPrice: json["totalPrice"]?.toDouble(),
    qrImage: json["qrImage"],
    unPaidMoney: json["unPaidMoney"]?.toDouble(),
    vehicleInfor: json["vehicleInfor"] == null ? null : VehicleInfor.fromJson(json["vehicleInfor"]),
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bookingId": bookingId,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "checkinTime": checkinTime?.toIso8601String(),
    "checkoutTime": checkoutTime?.toIso8601String(),
    "dateBook": dateBook?.toIso8601String(),
    "status": status,
    "guestName": guestName,
    "guestPhone": guestPhone,
    "totalPrice": totalPrice,
    "qrImage": qrImage,
    "unPaidMoney": unPaidMoney,
    "vehicleInfor": vehicleInfor?.toJson(),
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}

class Transaction {
  final int? transactionId;
  final double? price;
  final String? status;
  final String? paymentMethod;

  Transaction({
    this.transactionId,
    this.price,
    this.status,
    this.paymentMethod,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    transactionId: json["transactionId"],
    price: json["price"]?.toDouble(),
    status: json["status"],
    paymentMethod: json["paymentMethod"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "price": price,
    "status": status,
    "paymentMethod": paymentMethod,
  };
}

class VehicleInfor {
  final String? licensePlate;
  final String? vehicleName;
  final String? color;
  final int? trafficId;

  VehicleInfor({
    this.licensePlate,
    this.vehicleName,
    this.color,
    this.trafficId,
  });

  factory VehicleInfor.fromJson(Map<String, dynamic> json) => VehicleInfor(
    licensePlate: json["licensePlate"],
    vehicleName: json["vehicleName"],
    color: json["color"],
    trafficId: json["trafficId"],
  );

  Map<String, dynamic> toJson() => {
    "licensePlate": licensePlate,
    "vehicleName": vehicleName,
    "color": color,
    "trafficId": trafficId,
  };
}
