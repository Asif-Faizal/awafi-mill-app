import 'dart:convert';

import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'wishlist_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistModel>> getWishlistItems();
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final http.Client client;

  WishlistRemoteDataSourceImpl({required this.client});

  @override
  Future<List<WishlistModel>> getWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> dataList = data['data'];
      return dataList
          .map((item) => WishlistModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException(); // Custom exception
    }else if(response.statusCode == 403){
      final newToken = await _refreshToken(token!);
      if (newToken!= null) {
        await prefs.setString('jwtToken', newToken);
        return getWishlistItems();
      }
      else{
        throw UnauthenticatedException();
      }
    }
    else {
      throw Exception('Failed to load wishlist items');
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

class UnauthenticatedException implements Exception {}
