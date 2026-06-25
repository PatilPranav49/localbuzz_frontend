import 'package:flutter/material.dart';
import 'package:localbuzz_app/features/home/home_screen.dart';
import 'package:localbuzz_app/features/navigation/main_screen.dart';

import '../../../core/storage/token_storage.dart';
import 'login_screen.dart';
import '../../feed/feed_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final token = await TokenStorage.getToken();
    final role = await TokenStorage.getRole();

    //
    print(await TokenStorage.getToken());
    print(await TokenStorage.getRole());
    //
    if (!mounted) return;

    if (token == null ||
        token.isEmpty ||
        role == null ||
        role.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    } else {
      print("TOKEN: $token");
      print("ROLE : $role");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(role: role),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}