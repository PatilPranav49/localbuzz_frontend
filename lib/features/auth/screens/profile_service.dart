import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/user_profile.dart';

class ProfileService {

  static const String baseUrl =
      'http://10.0.2.2:8081';

  Future<UserProfile> getProfile() async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Authorization':
        'Bearer $token',
      },
    );

    if (response.statusCode == 200) {

      return UserProfile.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
        'Failed to load profile');
  }
}