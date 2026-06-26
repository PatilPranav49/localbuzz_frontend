import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../services/register_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RegisterService service = RegisterService();
  bool isLoading = false;
  bool obscure = true;
  String selectedRole = "USER";

  static const _roles = [
    ('USER', 'Explorer', Icons.explore_rounded),
    ('OWNER', 'Business Owner', Icons.storefront_rounded),
    ('COMMUNITY_ADMIN', 'Community Admin', Icons.groups_rounded),
  ];
  bool isValidEmail(String email) {
    return RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ).hasMatch(email);
  }
  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(password)) {
      return showMessage(
        "Password must contain at least one letter and one number",
      );
    }
    if (name.isEmpty) {
      return showMessage("Enter your name");
    }

    if (email.isEmpty) {
      return showMessage("Enter email");
    }

    if (!isValidEmail(email)) {
      return showMessage("Enter a valid email address");
    }

    if (password.isEmpty) {
      return showMessage("Enter password");
    }

    if (password.length < 8) {
      return showMessage("Password must be at least 8 characters");
    }

    if (confirmPassword.isEmpty) {
      return showMessage("Confirm your password");
    }

    if (password != confirmPassword) {
      return showMessage("Passwords do not match");
    }

    try {
    setState(() => isLoading = true);
    await service.register(
      name: name,
      email: email,
      password: password,
      role: selectedRole,
    );

    if (!mounted) return;
    String message = "You're all set — welcome to LocalBuzz!";
    if (selectedRole == "COMMUNITY_ADMIN") {
    message =
    "Registration successful.\n\nYour account is awaiting Admin approval.";
    }

    await showDialog(
    context: context,
    builder: (_) => AlertDialog(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    title: const Row(
    children: [
    Icon(Icons.celebration_rounded, color: AppColors.coral),
    SizedBox(width: 10),
    Text("You're in!"),
    ],
    ),
    content: Text(message),
    actions: [
    TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text("CONTINUE"),
    ),
    ],
    ),
    );

    if (!mounted) return;
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  } on DioException catch (e) {
  String message = "Something went wrong";
  switch (e.response?.statusCode) {
  case 409:
  message = "Email already registered";
  break;
  case 400:
  message = e.response?.data.toString() ?? "Invalid request";
  break;
  default:
  message = e.response?.data.toString() ?? "Something went wrong";
  }
  showMessage(message);
  } finally {
  if (mounted) setState(() => isLoading = false);
  }
}

void showMessage(String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}

@override
void dispose() {
  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(
                backgroundColor:
                theme.colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              child: Text(
                'Join the\nbuzz.',
                style: theme.textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              delayMs: 80,
              child: Text(
                'Become part of your neighborhood\'s living feed.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 28),

            FadeSlideIn(
              delayMs: 140,
              child: Text(
                'JOIN AS',
                style: theme.textTheme.labelMedium,
              ),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              delayMs: 180,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _roles.map((r) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: BuzzChoiceChip(
                        label: r.$2,
                        icon: r.$3,
                        selected: selectedRole == r.$1,
                        onTap: () => setState(() => selectedRole = r.$1),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            FadeSlideIn(
              delayMs: 220,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FadeSlideIn(
              delayMs: 250,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FadeSlideIn(
              delayMs: 280,
              child: TextField(
                controller: passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FadeSlideIn(
              delayMs: 310,
              child: TextField(
                controller: confirmPasswordController,
                obscureText: obscure,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
            ),
            const SizedBox(height: 28),

            FadeSlideIn(
              delayMs: 350,
              child: BuzzGradientButton(
                label: 'CREATE ACCOUNT',
                icon: Icons.arrow_forward_rounded,
                loading: isLoading,
                onPressed: isLoading ? null : register,
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Already onboard?  ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}