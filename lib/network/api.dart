import 'dart:convert';

import '../pages/models/login_response.dart';
import 'package:http/http.dart' as http;

const String host = 'http://parkzwebapiver2-001-site1.ctempurl.com';

Future<LoginResponse> login(phone) async {
  var response = await http.post(
      Uri.parse('$host/api/mobile/customer-authentication/login'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
      body: jsonEncode({"phone": phone}));
  final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
  return LoginResponse.fromJson(responseJson);
}