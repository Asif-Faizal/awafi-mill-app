import 'dart:convert';
import 'package:awafi/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'banner_model.dart';

class BannerRemoteDataSource {
  final http.Client client;

  BannerRemoteDataSource(this.client);

  Future<List<BannerModel>> fetchBanners() async {
    final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/banner/viewWelcomeBanner'));
    debugPrint(response.body);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['banners'] as List)
          .map((banner) => BannerModel.fromJson(banner))
          .toList();
    } else {
      throw Exception(message);
    }
  }
    Future<List<BannerModel>> fetchOfferBanners() async {
    final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/banner/viewOfferBanner'));
    debugPrint(response.body);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['banners'] as List)
          .map((banner) => BannerModel.fromJson(banner))
          .toList();
    } else {
      throw Exception(message);
    }
  }
    Future<List<BannerModel>> fetchCollectionBanners() async {
    final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/banner/viewCollectionBanner'));
    debugPrint(response.body);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['banners'] as List)
          .map((banner) => BannerModel.fromJson(banner))
          .toList();
    } else {
      throw Exception(message);
    }
  }
}
