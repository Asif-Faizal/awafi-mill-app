// category_remote_data_source.dart
import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> fetchCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/categories/listedCategory/?page=1&limit=9'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
