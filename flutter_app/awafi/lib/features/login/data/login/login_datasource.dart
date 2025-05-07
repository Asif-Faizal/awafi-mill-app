import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/login/login_entity.dart';
import 'login_model.dart';

abstract class LoginDataSource {
  Future<LoginEntity> loginWithEmail(LoginRequest request);
  Future<LoginEntity> loginWithNumber(LoginRequest request);
}

class LoginDataSourceImpl implements LoginDataSource {
  final http.Client client;

  LoginDataSourceImpl({required this.client});

  @override
  Future<LoginEntity> loginWithEmail(LoginRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': request.email,
        'password': request.password,
      }),
    );
    debugPrint(response.body);

    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    final token = responseData['token'];

    if (response.statusCode == 200) {
      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);

      // Returning LoginEntity from the response data
      return LoginEntity.fromJson(responseData);
    } else {
      throw Exception(message);
    }
  }

  @override
  Future<LoginEntity> loginWithNumber(LoginRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'number': request.number,
        'password': request.password,
      }),
    );

    debugPrint(response.body);

    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    final token = responseData['token'];

    if (response.statusCode == 200) {
      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);

      // Returning LoginEntity from the response data
      return LoginEntity.fromJson(responseData);
    } else {
      throw Exception(message);
    }
  }
}
