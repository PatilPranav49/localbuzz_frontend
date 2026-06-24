import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'models/community_post.dart';
import 'services/community_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

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

    final position =
    await Geolocator.getCurrentPosition();

    print('LAT: ${position.latitude}');
    print('LNG: ${position.longitude}');

    final result =
    await service.getPosts(
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community',
        ),
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder:
            (context, index) {

          final post =
          posts[index];

          return Card(
            margin:
            const EdgeInsets.all(10),
            child: Padding(
              padding:
              const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [

                  Chip(
                    label:
                    Text(post.type),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    post.title,
                    style:
                    const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    post.description,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Posted by ${post.authorName}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}