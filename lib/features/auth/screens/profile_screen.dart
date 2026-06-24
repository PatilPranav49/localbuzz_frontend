import 'package:flutter/material.dart';
import 'package:localbuzz_app/features/auth/screens/profile_service.dart';

import '../../../core/storage/token_storage.dart';

import '../models/user_profile.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final ProfileService profileService =
  ProfileService();

  UserProfile? profile;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    try {

      final result =
      await profileService.getProfile();

      setState(() {
        profile = result;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {

    await TokenStorage.clearToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const LoginPage(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : profile == null
          ? const Center(
        child:
        Text('Failed to load'),
      )
          : Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              profile!.name,
              style:
              const TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              profile!.email,
            ),

            const SizedBox(
              height: 30,
            ),

            ListTile(
              leading: const Icon(
                Icons.business,
              ),
              title: const Text(
                'My Businesses',
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(
                'Logout',
              ),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}