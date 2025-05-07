import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/api_config.dart';
import 'orders_model.dart';
import 'package:http/http.dart' as http;

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> fetchOrders(int page, int limit);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSourceImpl({required this.client});

  @override
  Future<List<OrderModel>> fetchOrders(int page, int limit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/orders/order/user/?page=1&limit=3'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['orders'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } else {
      throw Exception();
    }
  }
}
