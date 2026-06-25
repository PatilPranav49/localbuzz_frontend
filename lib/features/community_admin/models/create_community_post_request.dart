class CreateCommunityPostRequest {
  final String title;
  final String description;
  final String type;
  final double latitude;
  final double longitude;

  CreateCommunityPostRequest({
    required this.title,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "type": type,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}