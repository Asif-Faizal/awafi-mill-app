import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RefreshDatasource {
  Future<String?> refreshAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('jwtToken');

    if (accessToken == null) {
      print('Access token not found');
      return null;
    }

    // URL for refresh token endpoint
    final Uri url = Uri.parse('${ApiConfig.baseUrl}/user/refresh');

    // Headers with the current access token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // Sending the request to get the refresh token
    final response = await http.post(url, headers: headers);

    // Check if the refresh token request was successful
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final newToken = responseBody['token'];
      prefs.setString('jwtToken', newToken);
      return responseBody['token'];
    } else {
      print('Failed to refresh token: ${response.statusCode}');
      return null;
    }
  }
}