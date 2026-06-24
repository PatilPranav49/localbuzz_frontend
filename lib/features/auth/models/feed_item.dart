class FeedItem {
  final int updateId;
  final int? businessId;
  final String businessName;
  final String? category;
  final String? address;
  final String? coverImageUrl;
  final String title;
  final String description;
  final String updateType;
  final String createdAt;

  FeedItem({
    required this.updateId,
    required this.businessId,
    required this.businessName,
    required this.category,
    required this.address,
    required this.coverImageUrl,
    required this.title,
    required this.description,
    required this.updateType,
    required this.createdAt,
  });

  factory FeedItem.fromJson(
      Map<String, dynamic> json) {
    return FeedItem(
      updateId: json['updateId'],
      businessId: json['businessId'],
      businessName: json['businessName'],
      category: json['category'],
      address: json['address'],
      coverImageUrl: json['coverImageUrl'],
      title: json['title'],
      description: json['description'],
      updateType: json['updateType'],
      createdAt: json['createdAt'],
    );
  }
}