// datasources/product_data_source.dart
import 'package:awafi/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'product_model.dart';

class ProductDataSource {
  final http.Client client;

  ProductDataSource(this.client);

  Future<List<ProductModel>> fetchProducts() async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/products/product/listed/?page=1&limit=10'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);
    debugPrint("PRODUCT STATE: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
