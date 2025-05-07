import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'userData_model.dart';

abstract class UserDataDatasource {
  Future<UserDataModel> getUserData();
  Future<bool> editUserData(UserProfileData userModel);
}

class UserDataDatasourceImpl implements UserDataDatasource {
  final http.Client client;

  UserDataDatasourceImpl({required this.client});

  @override
  Future<UserDataModel> getUserData() async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserDataModel.fromJson(jsonDecode(response.body));
    }else if(response.statusCode == 403){
      final newToken = await _refreshToken(token!);
      if (newToken!= null) {
        await prefs.setString('jwtToken', newToken);
        return getUserData();
      }
      else{
        throw UnauthorizedException();
      }
    } else if (response.statusCode != 200) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load user data');
    }
  }
  @override
  Future<bool> editUserData(UserProfileData userModel) async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.patch(
      Uri.parse('${ApiConfig.baseUrl}/user/edit'), // Your API endpoint
      body: jsonEncode(userModel.toJson()),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    }else if(response.statusCode == 403){
      final newToken = await _refreshToken(token!);
      if (newToken!= null) {
        await prefs.setString('jwtToken', newToken);
        return editUserData(userModel);
      }
      else{
        throw UnauthorizedException();
      }
    }
     else if (response.statusCode != 200) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load user data');
    }
  }

    Future<String?> _refreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/refresh'),
      headers: {
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newToken = responseData['token'];
      if (newToken != null) {
        await prefs.setString('jwtToken', newToken);
        return newToken;
      }
    }
    return null; // Return null if the refresh token request fails
  }
}

class UnauthorizedException implements Exception {}
