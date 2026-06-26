import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/buzz_widgets.dart';
import '../community_admin/screens/create_community_post_screen.dart';
import 'models/community_post.dart';
import 'services/community_service.dart';

class CommunityScreen extends StatefulWidget {
  final bool canCreate;

  const CommunityScreen({super.key, this.canCreate = false});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService service = CommunityService();
  List<CommunityPost> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() => isLoading = true);
    final position = await Geolocator.getCurrentPosition();
    final result = await service.getPosts(position.latitude, position.longitude);
    if (!mounted) return;
    setState(() {
      posts = result;
      isLoading = false;
    });
  }

  Future<void> createPost() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCommunityPostScreen()),
    );
    if (created == true) await loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: widget.canCreate
          ? FloatingActionButton.extended(
        onPressed: createPost,
        icon: const Icon(Icons.add_rounded),
        label: const Text('NEW POST'),
      )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.coral,
          onRefresh: loadPosts,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        'The local pulse',
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Notices, events & alerts from your neighborhood.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.coral),
                  ),
                )
              else if (posts.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: BuzzEmptyState(
                    icon: Icons.forum_rounded,
                    title: 'Quiet around here',
                    message: 'No community posts yet. Check back soon!',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return FadeSlideIn(
                        delayMs: index * 50,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _PostCard(post: post),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BuzzCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BuzzBadge.forType(post.type),
              const Spacer(),
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: 4),
              Text(
                'Just now',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            post.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 14),
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.coral.withValues(alpha: 0.15),
                child: Text(
                  post.authorName.isNotEmpty
                      ? post.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                post.authorName,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}