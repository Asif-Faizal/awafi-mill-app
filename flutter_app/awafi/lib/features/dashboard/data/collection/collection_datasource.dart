import 'package:awafi/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'collection_model.dart';

abstract class CollectionRemoteDataSource {
  Future<List<CollectionModel>> fetchCollections();
}

class CollectionRemoteDataSourceImpl implements CollectionRemoteDataSource {
  final http.Client client;

  CollectionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CollectionModel>> fetchCollections() async {
    final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/sub-categories/category/sub/user?page=1&limit=4'));
    print('//////////////////////////////');
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((item) => CollectionModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch collections');
    }
  }
}
