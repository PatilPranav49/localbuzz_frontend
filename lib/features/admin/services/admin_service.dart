import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/pending_community_admin.dart';
import '../../../core/storage/token_storage.dart';
import '../models/pending_business.dart';

class AdminService {
  static const String baseUrl =
      "http://10.0.2.2:8081";

  Future<List<PendingBusiness>>
  getPendingBusinesses() async {
    final token =
    await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
          "$baseUrl/admin/businesses/pending"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data =
      jsonDecode(response.body);

      return data
          .map(
            (e) => PendingBusiness.fromJson(e),
      )
          .toList();
    }

    throw Exception(
        "Failed to load businesses");
  }

  Future<void> approveBusiness(
      int id) async {
    final token =
    await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse(
          "$baseUrl/admin/businesses/$id/approve"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Approval Failed");
    }
  }

  Future<List<PendingCommunityAdmin>>
  getPendingCommunityAdmins() async {

    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(
          "$baseUrl/admin/community-admins/pending"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data
          .map((e) =>
          PendingCommunityAdmin.fromJson(e))
          .toList();
    }

    throw Exception(
        "Failed to load Community Admins");
  }

  Future<void> approveCommunityAdmin(
      int id) async {

    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse(
          "$baseUrl/admin/community-admins/$id/approve"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Approval Failed");
    }
  }
}