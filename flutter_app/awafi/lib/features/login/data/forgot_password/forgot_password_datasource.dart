import 'dart:convert'; // Add this import

import '../../../../core/config/api_config.dart';
import 'forgot_password_model.dart';
import 'package:http/http.dart' as http;

abstract class ForgotPasswordDatasource {
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request);
  Future<ForgotPasswordResponse> verifyOtp(VerifyOtpRequest request);
  Future<ForgotPasswordResponse> changePassword(ChangePasswordRequest request);
}

class ForgotPasswordDatasourceImpl implements ForgotPasswordDatasource {
  final http.Client client;

  ForgotPasswordDatasourceImpl({required this.client});

  @override
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/forgot-password'),
      body: request.toJson(),
    );

    // Decode the response body
    final Map<String, dynamic> responseJson = json.decode(response.body);

    print(responseJson);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    // Return the ForgotPasswordResponse
    if(response.statusCode == 200){
      return ForgotPasswordResponse.fromJson(responseJson);
    }else{
      throw Exception(message);
    }
  }

  @override
  Future<ForgotPasswordResponse> verifyOtp(VerifyOtpRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/forgot-otpVeify'),
      body: request.toJson(),
    );

    // Decode the response body
    final Map<String, dynamic> responseJson = json.decode(response.body);

    print(responseJson);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if(response.statusCode == 200){
      return ForgotPasswordResponse.fromJson(responseJson);
    }else{
      throw Exception(message);
    }
  }

  @override
  Future<ForgotPasswordResponse> changePassword(ChangePasswordRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/forgot-setPassword'),
      body: request.toJson(),
    );

    // Decode the response body
    final Map<String, dynamic> responseJson = json.decode(response.body);

    print(responseJson);
    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    if(response.statusCode == 200){
      return ForgotPasswordResponse.fromJson(responseJson);
    }
    
    else{
      throw Exception(message);
    }
    
  }
}
