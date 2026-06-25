import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../community_admin/screens/create_community_post_screen.dart';
import 'models/community_post.dart';
import 'services/community_service.dart';

class CommunityScreen extends StatefulWidget {

  final bool canCreate;

  const CommunityScreen({
    super.key,
    this.canCreate = false,
  });

  @override
  State<CommunityScreen> createState() =>
      _CommunityScreenState();
}

class _CommunityScreenState
    extends State<CommunityScreen> {

  final CommunityService service =
  CommunityService();

  List<CommunityPost> posts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {

    setState(() {
      isLoading = true;
    });

    final position =
    await Geolocator.getCurrentPosition();

    print('LAT: ${position.latitude}');
    print('LNG: ${position.longitude}');

    final result = await service.getPosts(
      position.latitude,
      position.longitude,
    );

    print('POST COUNT: ${result.length}');

    if (!mounted) return;

    setState(() {
      posts = result;
      isLoading = false;
    });
  }

  Future<void> createPost() async {

    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const CreateCommunityPostScreen(),
      ),
    );

    if (created == true) {
      await loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Community"),
      ),

      floatingActionButton: widget.canCreate
          ? FloatingActionButton(
        onPressed: createPost,
        child: const Icon(Icons.add),
      )
          : null,

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: loadPosts,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {

            final post = posts[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding:
                const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Chip(
                      label: Text(post.type),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(post.description),

                    const SizedBox(height: 10),

                    Text(
                      "Posted by ${post.authorName}",
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}