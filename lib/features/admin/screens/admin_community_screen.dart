import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../models/pending_community_admin.dart';
import '../services/admin_service.dart';

class AdminCommunityScreen extends StatefulWidget {
  const AdminCommunityScreen({super.key});

  @override
  State<AdminCommunityScreen> createState() => _AdminCommunityScreenState();
}

class _AdminCommunityScreenState extends State<AdminCommunityScreen> {
  final AdminService service = AdminService();
  late Future<List<PendingCommunityAdmin>> admins;

  @override
  void initState() {
    super.initState();
    loadAdmins();
  }

  void loadAdmins() {
    admins = service.getPendingCommunityAdmins();
  }

  Future<void> approve(int id) async {
    await service.approveCommunityAdmin(id);
    setState(loadAdmins);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Community admin approved')),
    );
  }

  String _initialsOf(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<PendingCommunityAdmin>>(
          future: admins,
          builder: (context, snapshot) {
            final loading =
                snapshot.connectionState == ConnectionState.waiting;
            final list = snapshot.data ?? [];
            return RefreshIndicator(
              color: AppColors.coral,
              onRefresh: () async => setState(loadAdmins),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md + 2,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin', style: theme.textTheme.bodyMedium),
                          Text(
                            'Admin requests',
                            style: theme.textTheme.displayMedium,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.shield_moon_rounded,
                                color: AppColors.plum,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${list.length} community admins to review',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (loading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.coral,
                        ),
                      ),
                    )
                  else if (snapshot.hasError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: BuzzEmptyState(
                        icon: Icons.cloud_off_rounded,
                        title: 'Couldn\'t load requests',
                        message: snapshot.error.toString(),
                      ),
                    )
                  else if (list.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: BuzzEmptyState(
                          icon: Icons.verified_user_rounded,
                          title: 'Inbox zero',
                          message:
                          'No community admin requests are waiting right now.',
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          100,
                        ),
                        sliver: SliverList.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final admin = list[index];
                            return FadeSlideIn(
                              delayMs: index * 60,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md - 2,
                                ),
                                child: BuzzCard(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 54,
                                            height: 54,
                                            decoration: const BoxDecoration(
                                              gradient: AppColors.plumGradient,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              _initialsOf(admin.name),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  admin.name,
                                                  style: theme
                                                      .textTheme.headlineSmall,
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .alternate_email_rounded,
                                                      size: 14,
                                                      color: theme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                        alpha: 0.55,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        admin.email,
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: theme
                                                            .textTheme.bodyMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          BuzzBadge.forType('PENDING'),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      BuzzGradientButton(
                                        label: 'APPROVE COMMUNITY ADMIN',
                                        icon: Icons.verified_user_rounded,
                                        height: 48,
                                        onPressed: () => approve(admin.id),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}