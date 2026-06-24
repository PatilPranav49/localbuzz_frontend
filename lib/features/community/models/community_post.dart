class CommunityPost {
  final int id;
  final String title;
  final String description;
  final String type;
  final String authorName;
  final String createdAt;

  CommunityPost({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.authorName,
    required this.createdAt,
  });

  factory CommunityPost.fromJson(
      Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      authorName: json['authorName'],
      createdAt: json['createdAt'],
    );
  }
}