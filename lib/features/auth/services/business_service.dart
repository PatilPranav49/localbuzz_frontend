import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/business_profile.dart';

class BusinessService {

  static const String baseUrl =
      'http://10.0.2.2:8081';

  Future<BusinessProfile> getBusiness(
      int businessId) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/businesses/$businessId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {

      return BusinessProfile.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to load business',
    );
  }
}