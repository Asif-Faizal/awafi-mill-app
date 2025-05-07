import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'toggle_wishlist_model.dart';

abstract class ToggleWishlistRemoteDataSource {
  Future<void> addItemToWishlist(ToggleWishlistItemModel item);
  Future<void> removeItemFromWishlist(ToggleWishlistItemModel item);
}

class ToggleWishlistRemoteDataSourceImpl implements ToggleWishlistRemoteDataSource {
  final http.Client client;

  ToggleWishlistRemoteDataSourceImpl({required this.client});

  @override
  Future<void> addItemToWishlist(ToggleWishlistItemModel item) async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/wishlist/add'),
      body: json.encode(item.toJson()),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final responseData = jsonDecode(response.body);
    final error = responseData['error'];
    if(response.statusCode == 403){
      final newToken = await _refreshToken(token!);
      if(newToken!= null){
        await prefs.setString('jwtToken', newToken);
        await addItemToWishlist(item);
      }
      else{
        throw Exception('Failed to refresh token');
      }
    }
    else if (response.statusCode != 200) {
      throw Exception(error);
    }
  }

  @override
  Future<void> removeItemFromWishlist(ToggleWishlistItemModel item) async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/wishlist/remove'),
      body: json.encode(item.toJson()),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    final responseData = jsonDecode(response.body);
    final error = responseData['error'];
    if(response.statusCode == 403){
      final newToken = await _refreshToken(token!);
      if(newToken!= null){
        await prefs.setString('jwtToken', newToken);
        await removeItemFromWishlist(item);
      }
      else{
        throw Exception('Failed to refresh token');
      }
    }
    else if (response.statusCode != 200) {
      throw Exception(error);
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
