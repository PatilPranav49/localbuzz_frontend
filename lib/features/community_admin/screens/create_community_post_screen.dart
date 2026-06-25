import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/create_community_post_request.dart';
import '../services/community_admin_service.dart';

class CreateCommunityPostScreen extends StatefulWidget {
  const CreateCommunityPostScreen({super.key});

  @override
  State<CreateCommunityPostScreen> createState() =>
      _CreateCommunityPostScreenState();
}

class _CreateCommunityPostScreenState
    extends State<CreateCommunityPostScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final CommunityAdminService service =
  CommunityAdminService();

  bool isLoading = false;

  String selectedType = "NOTICE";

  Future<void> createPost() async {

    setState(() {
      isLoading = true;
    });

    try {

      Position position =
      await Geolocator.getCurrentPosition();

      final request = CreateCommunityPostRequest(
        title: titleController.text.trim(),
        description:
        descriptionController.text.trim(),
        type: selectedType,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await service.createPost(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Community Post Created",
          ),
        ),
      );

      Navigator.pop(context, true);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {

    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Create Community Post",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: "Post Type",
                border: OutlineInputBorder(),
              ),
              items: const [

                DropdownMenuItem(
                  value: "NOTICE",
                  child: Text("Notice"),
                ),

                DropdownMenuItem(
                  value: "EVENT",
                  child: Text("Event"),
                ),

                DropdownMenuItem(
                  value: "ALERT",
                  child: Text("Alert"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed:
                isLoading ? null : createPost,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}