import 'dart:convert';

import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'product_details_model.dart';

abstract class ProductIndividualRemoteDataSource {
  Future<ProductIndividualModel> getProductDetails(String productId);
}

class ProductIndividualRemoteDataSourceImpl implements ProductIndividualRemoteDataSource {
  final http.Client client;

  ProductIndividualRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductIndividualModel> getProductDetails(String productId) async {
      final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/products/product/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("PRODUCT DETAILS STATE: ${response.body}");
    final responseData = jsonDecode(response.body);
    final error = responseData['error'];
    if (response.statusCode == 200) {
      return ProductIndividualModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(error);
    }
  }
}
