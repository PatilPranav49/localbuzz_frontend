import 'package:flutter/material.dart';

import 'features/auth/screens/splash_screen.dart';

class LocalBuzzApp extends StatelessWidget {
  const LocalBuzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocalBuzz',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}