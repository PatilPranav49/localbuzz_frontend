import 'package:flutter/material.dart';

import '../admin/screens/admin_community_screen.dart';
import '../admin/screens/admin_business_screen.dart';
import '../community/community_screen.dart';
import '../home/home_screen.dart';
import '../owner/screens/owner_business_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String role;

  const MainScreen({
    super.key,
    required this.role,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late List<Widget> pages;
  late List<NavigationDestination> destinations;

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

        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            label: "Business",
          ),
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            label: "Community",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ];
        break;

      case "COMMUNITY_ADMIN":
        pages = const [
          CommunityScreen(canCreate: true),
          ProfileScreen(),
        ];

        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            label: "Community",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ];
        break;

      case "ADMIN":
        pages = const [
          AdminBusinessScreen(),
          AdminCommunityScreen(),
          ProfileScreen(),
        ];

        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            label: "Business",
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: "Community",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ];
        break;

      case "USER":
      default:
        pages = const [
          HomeScreen(),
          CommunityScreen(),
          ProfileScreen(),
        ];

        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            label: "Community",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: destinations,
      ),
    );
  }
}