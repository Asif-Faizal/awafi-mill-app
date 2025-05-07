import 'dart:convert';

import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'checkout_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<void> checkout(CheckoutModel checkoutModel);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final http.Client client;

  CheckoutRemoteDataSourceImpl({required this.client});

  @override
  Future<void> checkout(CheckoutModel checkoutModel) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String? refreshToken = prefs.getString('refreshToken');

    final response = await _makeCheckoutRequest(token, checkoutModel);

    // Handle 403 Unauthorized error by refreshing the token
    if (response.statusCode == 403 && refreshToken != null) {
      final refreshedToken = await _refreshToken(refreshToken);
      if (refreshedToken != null) {
        // Retry the checkout request with the new token
        token = refreshedToken;
        final retryResponse = await _makeCheckoutRequest(token, checkoutModel);
        if (retryResponse.statusCode != 200) {
          throw UnauthorisedException();
        }
      } else {
        throw UnauthorisedException();
      }
    } else if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  Future<http.Response> _makeCheckoutRequest(
    String? token,
    CheckoutModel checkoutModel,
  ) async {
    return await client.post(
      Uri.parse('${ApiConfig.baseUrl}/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(checkoutModel.toJson()),
    );
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

class UnauthorisedException implements Exception {}

class ServerException implements Exception {}
