import 'package:flutter/material.dart';

import '../../core/storage/token_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/buzz_widgets.dart';
import '../auth/models/user_profile.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
final ProfileService profileService = ProfileService();

UserProfile? profile;

bool isLoading = true;

@override
void initState() {
super.initState();
loadProfile();
}

Future<void> loadProfile() async {
try {
final result = await profileService.getProfile();

if (!mounted) return;

setState(() {
profile = result;
isLoading = false;
});
} catch (e) {
if (!mounted) return;

setState(() => isLoading = false);
}
}

Future<void> logout() async {
await TokenStorage.clearToken();

if (!mounted) return;

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (_) => const LoginPage(),
),
(route) => false,
);
}

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);

if (isLoading) {
return const Scaffold(
body: Center(
child: CircularProgressIndicator(
color: AppColors.coral,
),
),
);
}

if (profile == null) {
return const Scaffold(
body: BuzzEmptyState(
icon: Icons.error_outline_rounded,
title: 'Couldn\'t load profile',
message: 'Pull down to try again or sign in once more.',
),
);
}

final initials = profile!.name.trim().isEmpty
? '?'
: profile!.name
.trim()
.split(' ')
.where((p) => p.isNotEmpty)
.take(2)
.map((p) => p[0].toUpperCase())
.join();

return Scaffold(
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

Center(
child: Column(
children: [
Text(
'Profile',
style: theme.textTheme.bodyMedium,
),
Text(
'You',
style: theme.textTheme.displayMedium,
),
],
),
),

const SizedBox(height: 24),
FadeSlideIn(
child: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 340),
child: BuzzCard(
padding: const EdgeInsets.all(22),
child: Column(
children: [
Container(
width: 92,
height: 92,
decoration: BoxDecoration(
gradient: AppColors.sunsetGradient,
shape: BoxShape.circle,
boxShadow: [
BoxShadow(
color: AppColors.coral.withValues(alpha: 0.3),
blurRadius: 20,
offset: const Offset(0, 10),
),
],
),
child: Center(
child: Text(
initials,
style: const TextStyle(
fontSize: 32,
fontWeight: FontWeight.w900,
color: Colors.white,
letterSpacing: -1,
),
),
),
),

const SizedBox(height: 18),

Text(
profile!.name,
textAlign: TextAlign.center,
style: theme.textTheme.headlineMedium,
),

const SizedBox(height: 4),

Text(
profile!.email,
textAlign: TextAlign.center,
style: theme.textTheme.bodyMedium,
),

const SizedBox(height: 14),

Container(
padding: const EdgeInsets.symmetric(
horizontal: 14,
vertical: 6,
),
decoration: BoxDecoration(
color: AppColors.coral.withValues(alpha: 0.12),
borderRadius: BorderRadius.circular(
AppRadius.pill,
),
border: Border.all(
color: AppColors.coral.withValues(alpha: 0.3),
),
),
child: const Text(
'MEMBER',
style: TextStyle(
color: AppColors.coral,
fontWeight: FontWeight.w800,
letterSpacing: 1.2,
fontSize: 11,
),
),
),
],
),
),
),
),
),

const SizedBox(height: 24),
  FadeSlideIn(
    delayMs: 100,
    child: BuzzCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _Tile(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {},
          ),
          _Tile(
            icon: Icons.bookmark_outline_rounded,
            label: 'Saved places',
            onTap: () {},
          ),
          _Tile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {},
          ),
          _Tile(
            icon: Icons.help_outline_rounded,
            label: 'Help & feedback',
            onTap: () {},
          ),
        ],
      ),
    ),
  ),

  const SizedBox(height: 18),

  FadeSlideIn(
    delayMs: 160,
    child: BuzzCard(
      padding: EdgeInsets.zero,
      child: _Tile(
        icon: Icons.logout_rounded,
        label: 'Sign out',
        color: AppColors.error,
        onTap: logout,
      ),
    ),
  ),
],
),
),
),
);
}
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = color ?? scheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: tone,
                size: 18,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: tone,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}