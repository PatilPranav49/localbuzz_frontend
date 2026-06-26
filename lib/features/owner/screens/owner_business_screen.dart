import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../models/owner_business.dart';
import '../services/owner_service.dart';
import 'create_business_screen.dart';
import 'create_update_screen.dart';

class OwnerBusinessScreen extends StatefulWidget {
  const OwnerBusinessScreen({super.key});

  @override
  State<OwnerBusinessScreen> createState() => _OwnerBusinessScreenState();
}

class _OwnerBusinessScreenState extends State<OwnerBusinessScreen> {
  final OwnerService _service = OwnerService();
  late Future<List<OwnerBusiness>> businesses;

  @override
  void initState() {
    super.initState();
    loadBusinesses();
  }

  void loadBusinesses() {
    businesses = _service.getMyBusinesses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateBusinessScreen()),
          );
          setState(loadBusinesses);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('NEW BUSINESS'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<OwnerBusiness>>(
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
                          Text('Owner', style: theme.textTheme.bodyMedium),
                          Text(
                            'My businesses',
                            style: theme.textTheme.displayMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your listings and post updates.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 18),
                          if (!loading && list.isNotEmpty)
                            _StatsRow(list: list),
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
                        title: 'Something went wrong',
                        message: snapshot.error.toString(),
                      ),
                    )
                  else if (list.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: BuzzEmptyState(
                          icon: Icons.storefront_rounded,
                          title: 'No business yet',
                          message:
                          'Tap the + button to register your first business and start buzzing.',
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        sliver: SliverList.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return FadeSlideIn(
                              delayMs: index * 60,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _OwnerBusinessCard(business: list[index]),
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

class _StatsRow extends StatelessWidget {
  final List<OwnerBusiness> list;
  const _StatsRow({required this.list});

  @override
  Widget build(BuildContext context) {
    final approved = list.where((b) => b.status == 'APPROVED').length;
    final pending = list.length - approved;
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'TOTAL',
            value: '${list.length}',
            color: AppColors.plum,
            icon: Icons.storefront_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'LIVE',
            value: '$approved',
            color: AppColors.success,
            icon: Icons.verified_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'PENDING',
            value: '$pending',
            color: AppColors.warning,
            icon: Icons.schedule_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BuzzCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerBusinessCard extends StatelessWidget {
  final OwnerBusiness business;
  const _OwnerBusinessCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isApproved = business.status == 'APPROVED';
    final catStyle = CategoryStyle.of(business.category);
    return BuzzCard(
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
                      catStyle.color.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(catStyle.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(business.name, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      business.category,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              BuzzBadge.forType(business.status),
            ],
          ),
          const SizedBox(height: 16),
          _MetaRow(
            icon: Icons.location_on_rounded,
            color: AppColors.coral,
            text: business.address,
          ),
          const SizedBox(height: 8),
          _MetaRow(
            icon: Icons.phone_rounded,
            color: AppColors.success,
            text: business.phone.isEmpty ? 'Not available' : business.phone,
          ),
          const SizedBox(height: 8),
          _MetaRow(
            icon: Icons.public_rounded,
            color: AppColors.info,
            text: business.website.isEmpty
                ? 'Not available'
                : business.website,
          ),
          const SizedBox(height: 16),
          if (isApproved)
            BuzzGradientButton(
              label: 'CREATE UPDATE',
              icon: Icons.campaign_rounded,
              height: 48,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CreateUpdateScreen(businessId: business.id),
                  ),
                );
              },
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Waiting for admin approval',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _MetaRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}