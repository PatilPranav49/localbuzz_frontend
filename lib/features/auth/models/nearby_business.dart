class NearbyBusiness {
  final int businessId;
  final String businessName;
  final String category;
  final double distanceKm;
  final String latestUpdate;
  final double latitude;
  final double longitude;

  NearbyBusiness({
    required this.businessId,
    required this.businessName,
    required this.category,
    required this.distanceKm,
    required this.latestUpdate,
    required this.latitude,
    required this.longitude,
  });

  factory NearbyBusiness.fromJson(
      Map<String, dynamic> json) {
    return NearbyBusiness(
      businessId: json['businessId'],
      businessName: json['businessName'],
      category: json['category'],
      distanceKm:
      (json['distanceKm'] as num)
          .toDouble(),
      latestUpdate: json['latestUpdate'],
      latitude:
      (json['latitude'] as num)
          .toDouble(),
      longitude:
      (json['longitude'] as num)
          .toDouble(),
    );
  }
}