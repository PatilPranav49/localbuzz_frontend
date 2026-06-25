class PendingBusiness {
  final int id;
  final String name;
  final String description;
  final String address;
  final String category;
  final String status;

  PendingBusiness({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.status,
  });

  factory PendingBusiness.fromJson(Map<String, dynamic> json) {
    return PendingBusiness(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
    );
  }
}