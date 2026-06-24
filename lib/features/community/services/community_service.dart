import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/community_post.dart';
import '../../../core/storage/token_storage.dart';

class CommunityService {

  Future<List<CommunityPost>> getPosts(
      double lat,
      double lng,
      ) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2:8081/community?lat=$lat&lng=$lng',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    final data =
    jsonDecode(response.body) as List;

    return data
        .map((e) =>
        CommunityPost.fromJson(e))
        .toList();
  }
}