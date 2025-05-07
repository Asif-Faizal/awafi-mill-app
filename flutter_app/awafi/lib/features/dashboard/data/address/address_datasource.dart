// datasource/address_datasource.dart
import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'address_model.dart';

abstract class AddressDataSource {
  Future<AddressModel> getAddress();
}

class AddressDataSourceImpl implements AddressDataSource {
  final http.Client client;

  AddressDataSourceImpl(this.client);

  @override
  Future<AddressModel> getAddress() async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/user/user-address'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
debugPrint(response.body);
print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return AddressModel.fromJson(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } else if (response.statusCode == 404) {
      throw Exception("AddressNotFound");
    }else if (response.statusCode == 403) {
      throw UnauthenticatedAddressException;
    } else {
      throw Exception("Failed to retrieve address");
    }
  }
}
class UnauthenticatedAddressException implements Exception {}