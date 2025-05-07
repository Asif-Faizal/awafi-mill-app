import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'collection_product_model.dart';

abstract class CollectionProductRemoteDataSource {
  Future<List<CollectionProductModel>> getCollectionProducts(String subCategoryId);
}

class CollectionProductRemoteDataSourceImpl
    implements CollectionProductRemoteDataSource {
  final http.Client client;

  CollectionProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<CollectionProductModel>> getCollectionProducts(String subCategoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await client.get(
      Uri.parse("${ApiConfig.baseUrl}/products/product/subCategory/$subCategoryId?page=1&limit=5"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("COLLECTION PRODUCT RESPONSE: ${response.body}");
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => CollectionProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to fetch products.");
    }
  }
}
