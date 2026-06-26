import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../models/create_community_post_request.dart';
import '../services/community_admin_service.dart';
import '../../ai/services/ai_service.dart';
class CreateCommunityPostScreen extends StatefulWidget {
  const CreateCommunityPostScreen({super.key});

  @override
  State<CreateCommunityPostScreen> createState() =>
      _CreateCommunityPostScreenState();
}

class _CreateCommunityPostScreenState extends State<CreateCommunityPostScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final CommunityAdminService service = CommunityAdminService();
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  bool isLoading = false;
  String selectedType = 'NOTICE';
  final AIService _aiService = AIService();
  static const _types = [
    ('NOTICE', 'Notice', Icons.info_rounded),
    ('EVENT', 'Event', Icons.event_rounded),
    ('ALERT', 'Alert', Icons.warning_amber_rounded),
  ];

  Future<void> createPost() async {

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please generate or enter the details'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition();

      final request = CreateCommunityPostRequest(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: selectedType,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await service.createPost(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Community post created')),
      );

      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  Future<void> generateAnnouncement() async {
    if (titleController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter Event Name, Date and Location.',
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await _aiService.generateCommunityAnnouncement(
        eventName: titleController.text.trim(),
        date: dateController.text.trim(),
        location: locationController.text.trim(),
      );

      descriptionController.text = response;
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New community post'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              'Speak to the\nneighborhood.',
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Heads-ups, events, alerts — all in one place.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            Text('POST TYPE', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((t) {
                return BuzzChoiceChip(
                  label: t.$2,
                  icon: t.$3,
                  selected: selectedType == t.$1,
                  onTap: () => setState(() => selectedType = t.$1),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            Text('TITLE', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Short and clear',
              ),
            ),
            const SizedBox(height: 16),

            Text('EVENT DATE', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                hintText: 'e.g. 5 July 2026',
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
            ),

            const SizedBox(height: 16),

            Text('LOCATION', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: 'e.g. Central Garden',
                prefixIcon: Icon(Icons.location_on_rounded),
              ),
            ),const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : generateAnnouncement,
                icon: const Icon(Icons.auto_awesome),
                label: const Text("Generate with AI"),
              ),
            ),

            const SizedBox(height: 16),
            Text('DETAILS', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Add the full context here…',
              ),
            ),

            const SizedBox(height: 28),
            BuzzGradientButton(
              label: 'PUBLISH POST',
              icon: Icons.send_rounded,
              loading: isLoading,
              onPressed: isLoading ? null : createPost,
            ),
          ],
        ),
      ),
    );
  }
}