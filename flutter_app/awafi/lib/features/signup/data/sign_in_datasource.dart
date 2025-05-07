import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/config/api_config.dart';
import '../domain/sign_in_entity.dart';

class UserRemoteDataSource {
  Future<void> registerUser(UserEntity user) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/user/register'),
      body: jsonEncode(user.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint(response.body);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if (response.statusCode != 200) {
      throw Exception(message);
    }
  }

  Future<void> verifyOtp(OtpEntity otp) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/user/otpVerify'),
      body: jsonEncode(otp.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint(response.body);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if (response.statusCode != 200) {
      throw Exception(message);
    }
  }
}
