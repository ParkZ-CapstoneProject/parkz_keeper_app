import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../common/utils/util_widget.dart';
import '../models/base_response.dart';
import '../models/booking_detail_response.dart';
import '../models/bookings_response.dart';
import '../models/check_booking_response.dart';
import '../models/floors_response.dart';
import '../models/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/profile_response.dart';
import '../models/slots_response.dart';


const String host = 'https://parkzserver-001-site1.btempurl.com';

// Create storage
const storage = FlutterSecureStorage();

Future<LoginResponse> login(String email, String password, context) async {
  try {
    Utils(context).startLoading();
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password
    };
    var response = await http.post(
        Uri.parse('$host/api/business-manager-authentication'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'text/plain'
        },
        body: jsonEncode(requestBody)
    );
    if (response.statusCode >= 200 && response.statusCode <300) {
      final responseJson = jsonDecode(response.body);
      LoginResponse loginResponse =  LoginResponse.fromJson(responseJson);
      if(loginResponse.data!.token != null){
        //write token
        await storage.write(key: 'token', value: loginResponse.data!.token);

        //Parse data
        String normalizedSource = base64Url.normalize(loginResponse.data!.token!.split(".")[1]);
        String jsonString= utf8.decode(base64Url.decode(normalizedSource));
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        int userID = int.parse(jsonMap['_id']);
        //write user id
        await storage.write(key: 'userID', value: userID.toString());

        Utils(context).stopLoading();
        Utils(context).showSuccessSnackBar('${loginResponse.message}');
        return loginResponse;
      }else{
        Utils(context).stopLoading();
        Utils(context).showWarningSnackBar('Không tìm thấy token');
        throw Exception('Fail to login: Status code ${response.statusCode} Message ${response.body}');

      }
    } else {
      if(response.statusCode >= 400 && response.statusCode <500){
        final responseJson = jsonDecode(response.body);
        BaseResponse baseResponse =  BaseResponse.fromJson(responseJson);
        Utils(context).stopLoading();
        Utils(context).showWarningSnackBar('${baseResponse.message}');
        debugPrint(' Status code ${response.statusCode} Thất bại');
        throw Exception('Fail to login: Status code ${response.statusCode} Message ${response.body}');
      }else{
        Utils(context).stopLoading();
        throw Exception('Fail to login: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  }catch (e){
    throw Exception('Fail to login: $e');
  }
}

// Lấy chi tết đơn
Future<BookingDetailResponse> getBookingDetail(id) async {
  try {
    final response = await http.get(
      Uri.parse('$host/api/customer-booking/getbooked-booking-detail?BookingId=$id'),
      headers: {'accept': 'text/plain'},
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return BookingDetailResponse.fromJson(responseJson);
    } else {
      throw Exception(
          'Failed to fetch parking detail. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Fail to get parking detail: $e');
  }
}

// Check in cho customer
Future<bool> checkInBooking(int bookingId, context) async {
  try {
      Map<String, dynamic> requestBody = {
        "bookingId": bookingId
      };
      debugPrint('Check in bookin với : bookingId $bookingId');

      final response = await http.post(
          Uri.parse('$host/api/customer-booking/check-in'),
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(requestBody)
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        Utils(context).showSuccessSnackBar('Checkin Thành công');
        return true;
      }
        if(response.statusCode >= 400 && response.statusCode <500){
          final responseJson = jsonDecode(response.body);
          BaseResponse bookingResponse =  BaseResponse.fromJson(responseJson);
          Utils(context).showWarningSnackBar('${bookingResponse.message}');
          throw Exception('Fail to checkin: Status code ${response.statusCode} Message ${response.body}');
        }else{
          Utils(context).showErrorSnackBar('Checkin Thất bại');
          throw Exception('Fail to checkin: Status code ${response.statusCode} Message ${response.body}');
        }
  } catch (e) {
    throw Exception('Fail to checkin: $e');
  }
}

//Get booking list all
Future<BookingsResponse?> getBookingList(context) async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/booking-management-for-keeper/$userID/parkings?pageNo=1&pageSize=100'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        return BookingsResponse.fromJson(responseJson);
      } else {
        if(response.statusCode == 404){
          return null;
        }
        throw Exception('Fail to get all booking.: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to get all booking: $e');
  }
}


//Get booking list by filter
Future<BookingsResponse?> getBookingByFilter(dateFilter, status, context) async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/booking-management-for-keeper/filters/$userID/parkings?date=$dateFilter&status=$status&pageNo=1&pageSize=100'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        return BookingsResponse.fromJson(responseJson);
      } else {
        if(response.statusCode == 404){
          return null;
        }
        throw Exception('Fail to get filter booking.: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to get filter booking: $e');
  }
}

// Get booking list by search
Future<BookingsResponse?> getBookingBySearch(String searchString, context) async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    if(userID != null && token != null && searchString.trim() != ''){
      final response = await http.get(
        Uri.parse('$host/api/booking-management-for-keeper/keeper/$userID?searchString=$searchString'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        return BookingsResponse.fromJson(responseJson);
      } else {
        if(response.statusCode == 404){
          return null;
        }
        throw Exception('Fail to get search booking.: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to get search booking: $e');
  }
}

//Hủy đơn
Future<bool> cancelBooking(int bookingId, context) async {
  try {
    Map<String, dynamic> requestBody = {
      "bookingId": bookingId
    };

    final response = await http.post(
        Uri.parse('$host/api/customer-booking/cancel-booking'),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody)
    );
    if (response.statusCode >= 200 && response.statusCode <300) {
      //Giong nhau nen lay cai nay luon duoc
      Utils(context).showSuccessSnackBar('Hủy đơn đơn thành công');
      return true;
    }else {
      if(response.statusCode >= 400 && response.statusCode <500){
        Utils(context).showWarningSnackBar('Hủy đơn thất bại');
        throw Exception('Fail to cancel booking: Status code ${response.statusCode} Message ${response.body}');
      }else{
        throw Exception('Fail to cancel booking: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  } catch (e) {
    throw Exception('Fail to cancel booking: $e');
  }
}

// Duyệt đơn
Future<bool> approveBooking(int bookingId, context) async {
  try {
    Map<String, dynamic> requestBody = {
      "bookingId": bookingId
    };

    final response = await http.post(
        Uri.parse('$host/api/booking-management/approve-booking'),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody)
    );
    if (response.statusCode >= 200 && response.statusCode <300) {
      Utils(context).showSuccessSnackBar('Duyệt đơn thành công');
      return true;
    }else {
      if(response.statusCode >= 400 && response.statusCode <500){
        Utils(context).showWarningSnackBar('Duyệt đơn thất bại');
        throw Exception('Fail to approve booking: Status code ${response.statusCode} Message ${response.body}');
      }else{
        Utils(context).showWarningSnackBar('Duyệt đơn thất bại');
        throw Exception('Fail to approve booking: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  } catch (e) {
    Utils(context).showWarningSnackBar('Duyệt đơn thất bại');
    throw Exception('Fail to cancel booking: $e');
  }
}

// Check out
Future<String> checkoutBooking(int bookingId,int parkingId, String? payment, double? totalPrice) async {
  try {
    Map<String, dynamic> requestBody = {
      "bookingId": bookingId,
      "parkingId": parkingId,
      if (totalPrice != null) 'totalPrice': totalPrice,
      if (payment != null) 'paymentMethod': payment
    };
    debugPrint('---Request checkout Booking---');
    debugPrint(jsonEncode(requestBody));

    final response = await http.put(
        Uri.parse('$host/api/booking-management/check-out'),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody)
    );
    if (response.statusCode >= 200 && response.statusCode <300) {
      return 'true';
    }else {
      if(response.statusCode >= 400 && response.statusCode <500){
        final responseJson = jsonDecode(response.body);
        BaseResponse baseResponse = BaseResponse.fromJson(responseJson);
        return baseResponse.message.toString();
      }else{
        throw Exception('Fail to Check out booking: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  } catch (e) {
    throw Exception('Fail to Check out booking: $e');
  }
}

//Check info booking
Future<CheckBooking> getBookingAndCheck(id) async {
  try {
    final response = await http.get(
      Uri.parse('$host/api/keeper/booking-Infomation?BookingId=$id'),
      headers: {'accept': 'text/plain'},
    );
    if (response.statusCode >= 200 && response.statusCode <300) {
      final responseJson = jsonDecode(response.body);
      return CheckBooking.fromJson(responseJson);
    } else {
      throw Exception(
          'Failed to fetch booking checking detail fail. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Fail to get booking checking detail: $e');
  }
}

Future<CheckBooking?> checkoutOnline(int id, int? parkingId) async {
  try{
    CheckBooking booking = await getBookingAndCheck(id);
    if(booking.data!.booking!.unPaidMoney == 0){
      String checkoutStatus = await checkoutBooking(id, parkingId!, null, 0);
      if (checkoutStatus == 'true'){
        return null;
      }
      throw Exception('Can not checkout when success');
    }else{
      debugPrint('Số tiền chưa thanh toán : ${booking.data!.booking!.unPaidMoney}');
      return booking;
    }
  }catch(e){
    throw Exception('Can not checkout $e');
  }
}

Future<bool> doneBooking(int bookingId) async {
  try {
    Map<String, dynamic> requestBody = {
      "bookingId": bookingId,
    };
    debugPrint('---Request done Booking---');
    debugPrint(jsonEncode(requestBody));

    final response = await http.put(
        Uri.parse('$host/api/booking-management/done'),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody)
    );
    if(response.statusCode ==204){
        return true;
    }else {
      if(response.statusCode >= 400 && response.statusCode <500){
        throw Exception('Fail to Check out booking: Status code ${response.statusCode} Message ${response.body}');
      }else{
        throw Exception('Fail to Check out booking: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  } catch (e) {
    throw Exception('Fail to Check out booking: $e');
  }
}


// Lấy profile
Future<ProfileResponse?> getProfile(context) async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/keeper-account-management/$userID'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        ProfileResponse profileResponse = ProfileResponse.fromJson(responseJson);
        await storage.write(key: 'parkingId', value: profileResponse.data!.parkingId.toString());
        return profileResponse;
      } else {
        if(response.statusCode >= 400 && response.statusCode <500){
          final responseJson = jsonDecode(response.body);
          ProfileResponse depositResponse = ProfileResponse.fromJson(responseJson);
          Utils(context).showWarningSnackBar('${depositResponse.message}');
        }else{
          throw Exception('Fail to get profile info: Status code ${response.statusCode} Message ${response.body}');
        }
        throw Exception(
            'Failed to fetch profile info. Status code: ${response.statusCode}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to profile info:: $e');
  }
}


//Lấy danh sách tầng của 1 bãi xe
Future<List<Floor>> getFloorsByParking() async {
  try {
    String? parkingId = await storage.read(key: 'parkingId');

    if(parkingId != null){
      final response = await http.get(Uri.parse('$host/api/floors/parking/$parkingId'),
          headers: {
            'accept': 'application/json',
          });

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        FloorsResponse floorsResponse = FloorsResponse.fromJson(responseJson);
        return floorsResponse.data!;
      }
      if (response.statusCode == 401){
        throw Exception('Failed to fetch parking list. Status code: ${response.statusCode}');
      }
      else {
        throw Exception('Failed to fetch parking list. Status code: ${response.statusCode}');
      }
    }
    throw Exception('Chưa đăng nhập');
  } catch (e) {
    throw Exception('Fail to get parking detail: $e');
  }
}
// Hàm get slot sài ke vs customer
Future<SlotsResponse> getSlotsParkingByFloor(id, startDateTime, endDateTime) async {
  try {
    // Print the request body before sending
    debugPrint('---Request Get Parking Slot---');
    debugPrint('FloorId : $id');
    debugPrint('StartTimeBooking : $startDateTime');
    debugPrint('EndTimeBooking : $endDateTime');

    final response = await http.get(
      Uri.parse('$host/api/parking-slots/floors/floorId/parking-slots?FloorId=$id&StartTimeBooking=$startDateTime&EndTimeBooking=$endDateTime'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return SlotsResponse.fromJson(responseJson);
    } else {
      throw Exception('Failed to fetch parking list. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Fail to get parking detail: $e');
  }
}


