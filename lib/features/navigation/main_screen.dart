
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../admin/screens/admin_business_screen.dart';
import '../admin/screens/admin_community_screen.dart';
import '../community/community_screen.dart';
import '../home/home_screen.dart';
import '../owner/screens/owner_business_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String role;

  const MainScreen({super.key, required this.role});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late List<Widget> pages;
  late List<_NavItem> items;

  @override
  void initState() {
    super.initState();

    switch (widget.role) {
    case "OWNER":
    pages = const [
    OwnerBusinessScreen(),
    CommunityScreen(),
    ProfileScreen(),
    ];
    items = const [
    _NavItem(Icons.storefront_outlined, Icons.storefront_rounded, "Business"),
    _NavItem(Icons.forum_outlined, Icons.forum_rounded, "Community"),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, "Profile"),
    ];
    break;

    case "COMMUNITY_ADMIN":
    pages = const [
    CommunityScreen(canCreate: true),
    ProfileScreen(),
    ];
    items = const [
    _NavItem(Icons.forum_outlined, Icons.forum_rounded, "Community"),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, "Profile"),
    ];
    break;

    case "ADMIN":
    pages = const [
    AdminBusinessScreen(),
    AdminCommunityScreen(),
    ProfileScreen(),
    ];
    items = const [
    _NavItem(Icons.fact_check_outlined, Icons.fact_check_rounded, "Businesses"),
    _NavItem(Icons.admin_panel_settings_outlined, Icons.admin_panel_settings_rounded, "Admins"),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, "Profile"),
    ];
    break;

    case "USER":
    default:
    pages = const [
    HomeScreen(),
    CommunityScreen(),
    ProfileScreen(),
    ];
    items = const [
    _NavItem(Icons.explore_outlined, Icons.explore_rounded, "Discover"),
    _NavItem(Icons.forum_outlined, Icons.forum_rounded, "Community"),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, "Profile"),
    ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final item = items[i];
                final selected = currentIndex == i;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => currentIndex = i),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? AppColors.sunsetGradient
                            : null,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected ? item.activeIcon : item.icon,
                            color: selected
                                ? Colors.white
                                : scheme.onSurface.withValues(alpha: 0.6),
                            size: 22,
                          ),
                          if (selected) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.label,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}