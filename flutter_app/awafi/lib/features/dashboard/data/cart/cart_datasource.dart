// cart_data_source_impl.dart
import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'cart_model.dart';

abstract class CartDataSource {
  Future<List<CartItemModel>> fetchCartItems();
  Future<List<CartItemModel>> updateCartQuantity(
      String productId, String variantId, int quantity);
  Future<List<CartItemModel>> removeCartItem(
      String productId, String variantId);
}

class CartDataSourceImpl implements CartDataSource {
  // Helper method to get the JWT token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  // Helper method to get the refresh token
  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  // Method to refresh the JWT token
  Future<String?> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/user/refresh'),
      headers: {
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['token'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('jwtToken', newToken); // Save the new token
      return newToken;
    } else {
      throw UnauthenticatedException();
    }
  }

  @override
  Future<List<CartItemModel>> fetchCartItems() async {
    try {
      String? token = await _getToken();
      var response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cart'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        if (data.isEmpty) {
          throw CartNotFoundException();
        }
        return data.map((item) => CartItemModel.fromJson(item)).toList();
      } else if (response.statusCode == 204) {
        throw CartNotFoundException();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw UnauthenticatedException();
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      if (e is UnauthenticatedException || e is CartNotFoundException) {
        rethrow;
      }
      throw Exception('Error fetching cart items: $e');
    }
  }

  @override
  Future<List<CartItemModel>> updateCartQuantity(
      String productId, String variantId, int quantity) async {
    try {
      String? token = await _getToken();
      var response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/cart/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': productId,
          'variantId': variantId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return await fetchCartItems(); // Fetch updated cart
      } else if (response.statusCode == 401) {
        throw UnauthenticatedException();
      } else if (response.statusCode == 403) {
        // Attempt to refresh the token and retry
        token = await _refreshToken();
        return updateCartQuantity(productId, variantId, quantity); // Retry with new token
      } else {
        throw Exception('Failed to update cart quantity');
      }
    } catch (e) {
      throw Exception('Error updating cart quantity: $e');
    }
  }

  @override
  Future<List<CartItemModel>> removeCartItem(
      String productId, String variantId) async {
    try {
      String? token = await _getToken();
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/cart/remove'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': productId,
          'variantId': variantId,
        }),
      );

      if (response.statusCode == 200) {
        return await fetchCartItems(); // Fetch updated cart
      } else if (response.statusCode == 403) {
        // Attempt to refresh the token and retry
        token = await _refreshToken();
        return removeCartItem(productId, variantId); // Retry with new token
      } else {
        throw Exception('Failed to remove cart item');
      }
    } catch (e) {
      throw Exception('Error removing cart item: $e');
    }
  }
}

class UnauthenticatedException implements Exception {}

class CartNotFoundException implements Exception {
  @override
  String toString() => 'Cart not found';
}