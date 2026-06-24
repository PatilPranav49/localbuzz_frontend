import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/nearby_business.dart';

class NearbyBusinessService {

  static const String baseUrl =
      'http://10.0.2.2:8081';

  Future<List<NearbyBusiness>>
  getNearbyBusinesses({
    required double lat,
    required double lng,
    required double radius,
  }) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/feed/nearby?lat=$lat&lng=$lng&radius=$radius',
      ),
      headers: {
        'Authorization':
        'Bearer $token',
      },
    );

    if (response.statusCode == 200) {

      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) =>
            NearbyBusiness.fromJson(e),
      )
          .toList();
    }

    throw Exception(
        'Failed to load nearby businesses');
  }
}