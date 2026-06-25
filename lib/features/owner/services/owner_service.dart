import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/owner_business.dart';

class OwnerService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  Future<List<OwnerBusiness>> getMyBusinesses() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/businesses/my'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);

      return json
          .map((e) => OwnerBusiness.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load businesses');
  }

  Future<void> createBusiness({
    required String name,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required String phone,
    required String website,
    required String coverImageUrl,
    required String category,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/businesses'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'website': website,
        'coverImageUrl': coverImageUrl,
        'category': category,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception('Failed to create business');
    }
  }

  Future<void> createUpdate({
    required int businessId,
    required String title,
    required String description,
    required String type,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/updates'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'businessId': businessId,
        'title': title,
        'description': description,
        'type': type,
      }),
    );



    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception('Failed to create update');
    }
  }
}