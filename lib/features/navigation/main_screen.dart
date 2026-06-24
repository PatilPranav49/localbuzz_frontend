import 'package:flutter/material.dart';

import '../community/community_screen.dart';
import '../home/home_screen.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {

  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          print('TAB CLICKED: $index');
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}