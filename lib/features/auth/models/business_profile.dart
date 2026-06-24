import '../../auth/models/feed_item.dart';

class BusinessProfile {
  final int id;
  final String name;
  final String category;
  final String address;
  final String description;
  final List<FeedItem> recentUpdates;
  final double latitude;
  final double longitude;

  BusinessProfile({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.recentUpdates,
    required this.latitude,
    required this.longitude,
  });

  factory BusinessProfile.fromJson(
      Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      address: json['address'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      recentUpdates:
      (json['recentUpdates'] as List)
          .map(
            (e) => FeedItem.fromJson(e),
      )
          .toList(),
    );
  }
}