import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../models/pending_business.dart';
import '../services/admin_service.dart';

class AdminBusinessScreen extends StatefulWidget {
  const AdminBusinessScreen({super.key});

  @override
  State<AdminBusinessScreen> createState() => _AdminBusinessScreenState();
}

class _AdminBusinessScreenState extends State<AdminBusinessScreen> {
  final AdminService service = AdminService();
  late Future<List<PendingBusiness>> businesses;

  @override
  void initState() {
    super.initState();
    loadBusinesses();
  }

  void loadBusinesses() {
    businesses = service.getPendingBusinesses();
  }

  Future<void> approve(int id) async {
    await service.approveBusiness(id);
    setState(loadBusinesses);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Business approved')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<PendingBusiness>>(
          future: businesses,
          builder: (context, snapshot) {
            final loading = snapshot.connectionState == ConnectionState.waiting;
            final list = snapshot.data ?? [];
            return RefreshIndicator(
              color: AppColors.coral,
              onRefresh: () async => setState(loadBusinesses),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin', style: theme.textTheme.bodyMedium),
                          Text(
                            'Business queue',
                            style: theme.textTheme.displayMedium,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.hourglass_top_rounded,
                                color: AppColors.warning,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${list.length} awaiting review',
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
                        title: 'Something broke',
                        message: snapshot.error.toString(),
                      ),
                    )
                  else if (list.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: BuzzEmptyState(
                          icon: Icons.task_alt_rounded,
                          title: 'All clear',
                          message: 'No businesses pending approval right now.',
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final b = list[index];
                            final catStyle = CategoryStyle.of(b.category);
                            return FadeSlideIn(
                              delayMs: index * 60,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: BuzzCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  catStyle.color,
                                                  catStyle.color.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                14,
                                              ),
                                            ),
                                            child: Icon(
                                              catStyle.icon,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  b.name,
                                                  style:
                                                  theme.textTheme.headlineSmall,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  b.category,
                                                  style:
                                                  theme.textTheme.labelMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                          BuzzBadge.forType(b.status),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 16,
                                            color: AppColors.coral,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              b.address,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      BuzzGradientButton(
                                        label: 'APPROVE BUSINESS',
                                        icon: Icons.verified_rounded,
                                        height: 48,
                                        onPressed: () => approve(b.id),
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