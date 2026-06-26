import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';

class AIService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  Future<String> generateBusinessDescription({
    required String businessName,
    required String category,
    required String services,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/ai/business-description'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'businessName': businessName,
        'category': category,
        'services': services,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    }

    throw Exception('Failed to generate business description');
  }

  Future<String> generatePromotionalPost({
    required String keywords,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/ai/promotional-post'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'keywords': keywords,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    }

    throw Exception('Failed to generate promotional post');
  }

  Future<String> generateCommunityAnnouncement({
    required String eventName,
    required String date,
    required String location,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/ai/community-post'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'eventName': eventName,
        'date': date,
        'location': location,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    }

    throw Exception('Failed to generate community announcement');
  }
}