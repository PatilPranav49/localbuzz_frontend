import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/buzz_widgets.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _selectedCategory = 'All';

  static const _categories = <(String, IconData)>[
    ('All', Icons.dashboard_rounded),
    ('Cafe', Icons.local_cafe_rounded),
    ('Restaurant', Icons.restaurant_rounded),
    ('Gym', Icons.fitness_center_rounded),
    ('Shop', Icons.shopping_bag_rounded),
    ('Salon', Icons.content_cut_rounded),
    ('Service', Icons.handshake_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today', style: theme.textTheme.bodyMedium),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'LocalBuzz',
                            style: theme.textTheme.displayMedium,
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.sunsetGradient,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.coral.withValues(alpha: 0.3),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fresh from your neighborhood.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // Search field
            SliverToBoxAdapter(
              child: FadeSlideIn(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Search businesses, offers, events…',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.sunsetGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Category chip row (sticky-friendly, horizontal scroller — no wrap)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final c = _categories[i];
                    return BuzzChoiceChip(
                      label: c.$1,
                      icon: c.$2,
                      selected: _selectedCategory == c.$1,
                      onTap: () =>
                          setState(() => _selectedCategory = c.$1),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: BuzzSectionHeader(
                  icon: Icons.campaign_rounded,
                  title: 'Live updates',
                  subtitle: 'Offers, events & announcements nearby',
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Empty state — feed not yet wired
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                child: FadeSlideIn(
                  delayMs: 120,
                  child: BuzzCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.lg,
                    ),
                    child: BuzzEmptyState(
                      icon: Icons.campaign_outlined,
                      title: 'Your feed is warming up',
                      message:
                      'Business updates from your neighborhood will show up here as soon as they go live.',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
