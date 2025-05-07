// datasource/cart_remote_datasource.dart
import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../refresh/refresh_datasource.dart';
import 'add_cart_model.dart';

abstract class AddCartDatasource {
  Future<bool> addCartItem(AddCartItemModel cartItem);
}

class AddCartDatasourceImpl implements AddCartDatasource {
  final http.Client client;
  final RefreshDatasource refreshDatasource;

  AddCartDatasourceImpl({required this.client,required this.refreshDatasource});

  @override
  Future<bool> addCartItem(AddCartItemModel cartItem) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    final url = Uri.parse('${ApiConfig.baseUrl}/cart/add');  // Your endpoint for adding cart items

    // Prepare the request body
    final body = json.encode(cartItem.toJson());

    // Send the POST request
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print(response.body);
    final responseData = jsonDecode(response.body);
    final error = responseData["message"];
    // Return true if the status code is 200, else throw an exception
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
        // Try refreshing the token
        final newToken = await refreshDatasource.refreshAccessToken();
        if (newToken != null) {
          // Retry the request with the new token
          token = newToken;
          final retryResponse = await client.post(
            Uri.parse('${ApiConfig.baseUrl}/cart/add'),
            body: json.encode(cartItem.toJson()),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );

          if (retryResponse.statusCode == 200) {
            return jsonDecode(retryResponse.body);
          } else {
            throw Exception(error);
          }
        } else {
          throw Exception(error);
        }
      } else {
      throw Exception(error);
    }
  }
}
