
import 'theme/app_theme.dart';
import 'package:flutter/material.dart';
class BuzzGradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final Gradient? gradient;
  final double height;

  const BuzzGradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.gradient,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.55 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              gradient: gradient ?? AppColors.sunsetGradient,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: disabled
                  ? null
                  : [
                BoxShadow(
                  color: AppColors.coral.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft glassy card for content groupings.
class BuzzCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;

  const BuzzCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: color ?? scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border:
            border ??
                Border.all(color: scheme.outline.withValues(alpha: 0.5)),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Branded section header with optional trailing widget.
class BuzzSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final IconData? icon;

  const BuzzSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.sunsetGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Friendly empty state with icon & call-to-action.
class BuzzEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const BuzzEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.coral.withValues(alpha: 0.15),
                    AppColors.amber.withValues(alpha: 0.15),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.coral),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// A category-tinted badge (used for OFFER / EVENT / etc).
class BuzzBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const BuzzBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  static const Map<String, Color> typeColors = {
    'OFFER': AppColors.coral,
    'EVENT': AppColors.plum,
    'ANNOUNCEMENT': AppColors.info,
    'PRODUCT': AppColors.teal,
    'SERVICE': AppColors.amber,
    'NOTICE': AppColors.info,
    'ALERT': AppColors.error,
    'APPROVED': AppColors.success,
    'PENDING': AppColors.warning,
    'REJECTED': AppColors.error,
  };

  static const Map<String, IconData> typeIcons = {
    'OFFER': Icons.local_offer_rounded,
    'EVENT': Icons.event_rounded,
    'ANNOUNCEMENT': Icons.campaign_rounded,
    'PRODUCT': Icons.shopping_bag_rounded,
    'SERVICE': Icons.handshake_rounded,
    'NOTICE': Icons.info_rounded,
    'ALERT': Icons.warning_amber_rounded,
    'APPROVED': Icons.verified_rounded,
    'PENDING': Icons.schedule_rounded,
    'REJECTED': Icons.block_rounded,
  };

  factory BuzzBadge.forType(String type) {
    final upper = type.toUpperCase();
    return BuzzBadge(
      label: upper,
      color: typeColors[upper] ?? AppColors.plum,
      icon: typeIcons[upper],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mapping of business category to friendly icon & accent.
class CategoryStyle {
  final IconData icon;
  final Color color;
  const CategoryStyle(this.icon, this.color);

  static const Map<String, CategoryStyle> all = {
    'CAFE': CategoryStyle(Icons.local_cafe_rounded, Color(0xFFB45309)),
    'GYM': CategoryStyle(Icons.fitness_center_rounded, AppColors.error),
    'RESTAURANT': CategoryStyle(Icons.restaurant_rounded, AppColors.coral),
    'SALON': CategoryStyle(Icons.content_cut_rounded, AppColors.plum),
    'SHOP': CategoryStyle(Icons.shopping_bag_rounded, AppColors.teal),
    'SERVICE': CategoryStyle(Icons.handshake_rounded, AppColors.amber),
  };

  static CategoryStyle of(String? cat) =>
      all[(cat ?? '').toUpperCase()] ??
          const CategoryStyle(Icons.storefront_rounded, AppColors.plum);
}

/// A pill-shaped choice chip with selected gradient state.
class BuzzChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  const BuzzChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: selected ? AppColors.sunsetGradient : null,
        color: selected ? null : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: selected
              ? Colors.transparent
              : scheme.outline.withValues(alpha: 0.5),
        ),
        boxShadow: selected
            ? [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 15,
                    color: selected ? Colors.white : scheme.onSurface,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.2,
                    color: selected ? Colors.white : scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtle animated entrance wrapper.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int delayMs;

  const FadeSlideIn({super.key, required this.child, this.delayMs = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, c) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: c,
          ),
        );
      },
      child: child,
    );
  }
}