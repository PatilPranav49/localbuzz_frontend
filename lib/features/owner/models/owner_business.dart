class OwnerBusiness {
  final int id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String website;
  final String coverImageUrl;
  final String category;
  final String status;
  final bool active;
  final String createdAt;

  OwnerBusiness({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.website,
    required this.coverImageUrl,
    required this.category,
    required this.status,
    required this.active,
    required this.createdAt,
  });

  factory OwnerBusiness.fromJson(Map<String, dynamic> json) {
    return OwnerBusiness(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      active: json['active'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}