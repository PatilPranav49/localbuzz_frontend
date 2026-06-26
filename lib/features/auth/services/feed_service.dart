import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../core/storage/token_storage.dart';
import '../models/feed_item.dart';

class FeedService {

  static const String baseUrl =
      'http://10.0.2.2:8081';

  Future<List<FeedItem>> getFeed() async {
    final token = await TokenStorage.getToken();
    final response =
    await http.get(
      Uri.parse('${baseUrl}/feed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );



    if (response.statusCode == 200) {

      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => FeedItem.fromJson(e),
      )
          .toList();
    }

    throw Exception('Failed to load feed');
  }

  Future<List<FeedItem>> getFeedByType(
      String type) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
        '${baseUrl}/feed?type=$type',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {

      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => FeedItem.fromJson(e),
      )
          .toList();
    }

    throw Exception('Failed to load feed');
  }

  Future<List<FeedItem>> getFeedByCategory(
      String category) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
        '${baseUrl}/feed?category=$category',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map((e) => FeedItem.fromJson(e))
          .toList();
    }

    throw Exception(
        'Failed to load category feed');
  }


  Future<List<FeedItem>> getFilteredFeed(
      String url) async {

    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {

      final List<dynamic> data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => FeedItem.fromJson(e),
      )
          .toList();
    }

    throw Exception('Failed to load feed');
  }

}