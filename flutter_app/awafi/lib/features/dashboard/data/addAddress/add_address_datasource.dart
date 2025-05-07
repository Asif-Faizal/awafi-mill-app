import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../refresh/refresh_datasource.dart';
import 'add_address_model.dart';

abstract class AddAddressDatasource {
  Future<Map<String, dynamic>> addAddress(AddAddressModel address);
}

class AddAddressDatasourceImpl implements AddAddressDatasource {
  final http.Client client;
  final RefreshDatasource refreshDatasource;

  AddAddressDatasourceImpl({required this.client, required this.refreshDatasource});

  @override
  Future<Map<String, dynamic>> addAddress(AddAddressModel address) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    final url = '${ApiConfig.baseUrl}/user/add-address'; // Replace with your actual API endpoint

    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode(address.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('//////////////////////////////////////////////');
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 403) {
        // Try refreshing the token
        final newToken = await refreshDatasource.refreshAccessToken();
        if (newToken != null) {
          // Retry the request with the new token
          token = newToken;
          final retryResponse = await client.post(
            Uri.parse(url),
            body: jsonEncode(address.toJson()),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );

          if (retryResponse.statusCode == 200) {
            return jsonDecode(retryResponse.body);
          } else {
            return {'status_code': 403, 'message': 'Unauthorized access after refresh'};
          }
        } else {
          return {'status_code': 403, 'message': 'Failed to refresh token'};
        }
      } else {
        throw Exception('Failed to add address');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
