class PendingCommunityAdmin {
  final int id;
  final String name;
  final String email;

  PendingCommunityAdmin({
    required this.id,
    required this.name,
    required this.email,
  });

  factory PendingCommunityAdmin.fromJson(
      Map<String, dynamic> json) {
    return PendingCommunityAdmin(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}