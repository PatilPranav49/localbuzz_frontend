import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/create_community_post_request.dart';

class CommunityAdminService {
  static const String baseUrl =
      "http://10.0.2.2:8081";

  Future<void> createPost(
      CreateCommunityPostRequest request) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/community"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        "Failed to create community post",
      );
    }
  }
}