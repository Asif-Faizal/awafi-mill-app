import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'sub_category_product_model.dart';

abstract class SubCategoryProductDatasource {
  Future<List<SubCategoryProductModel>> getProductsBySubCategory(String subCategoryId);
}

class SubCategoryProductDatasourceImpl implements SubCategoryProductDatasource {
  final http.Client client;

  SubCategoryProductDatasourceImpl({required this.client});

  @override
  Future<List<SubCategoryProductModel>> getProductsBySubCategory(String subCategoryId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/products/product/subCategory/$subCategoryId?page=1&limit=5');
    final response = await client.get(url);
    print("SUB CATEGORY PRODUCT RESPONSE: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubCategoryProductModel.fromJson(json)).toList();
    } else if (response.statusCode == 403) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load products');
    }
  }
}
