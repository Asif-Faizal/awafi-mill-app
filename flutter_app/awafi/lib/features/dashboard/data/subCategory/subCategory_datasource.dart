// datasource/sub_category_remote_data_source.dart
import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'subCategory_model.dart';

abstract class SubCategoryRemoteDataSource {
  Future<List<SubCategoryModel>> getSubCategories(String mainCategoryId, int page, int limit);
}

class SubCategoryRemoteDataSourceImpl implements SubCategoryRemoteDataSource {
  final http.Client client;

  SubCategoryRemoteDataSourceImpl(this.client);

  @override
  Future<List<SubCategoryModel>> getSubCategories(String mainCategoryId, int page, int limit) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/sub-categories/listedCategory/sub/$mainCategoryId?page=$page&limit=$limit'),
    );
    print("SUB CATEGORY RESPONSE: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) => SubCategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }
}
