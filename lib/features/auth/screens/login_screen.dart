import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localbuzz_app/features/navigation/main_screen.dart';

import '../../../core/storage/token_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import 'register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = "USER";
  bool isLoading = false;
  bool obscure = true;
  String result = '';

  static const _roles = [
    ('USER', 'Explorer', Icons.explore_rounded),
    ('OWNER', 'Business Owner', Icons.storefront_rounded),
    ('COMMUNITY_ADMIN', 'Community Admin', Icons.groups_rounded),
    ('ADMIN', 'Admin', Icons.shield_rounded),
  ];
  bool isValidEmail(String email) {
    return RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ).hasMatch(email);
  }
Future<void> login() async {
final email = emailController.text.trim();
final password = passwordController.text.trim();

if (email.isEmpty) {
return showMessage("Enter your email");
}

if (!isValidEmail(email)) {
return showMessage("Enter a valid email address");
}

if (password.isEmpty) {
return showMessage("Enter your password");
}

    try {
      setState(() => isLoading = true);

      final response = await Dio().post(
        'http://10.0.2.2:8081/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['token'];
      final role = response.data['role'];
      if (role.toString() != selectedRole) {
        throw DioException(
          requestOptions: RequestOptions(path: '/users/login'),
          response: Response(
              requestOptions: RequestOptions(path: '/users/login'),
              statusCode: 403,
              data: "Please select the correct role.",
          ),
        );
      }
      await TokenStorage.saveToken(token);
      await TokenStorage.saveRole(role);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen(role: role)),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome back to LocalBuzz!')),
      );
    } catch (e) {
      String errorMessage = "Something went wrong";
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
        case 401:
        errorMessage = "Invalid email or password";
        break;
        case 403:
        errorMessage =
        e.response?.data?.toString() ??
        "Your account is awaiting admin approval.";
        break;
        case 404:
        errorMessage = "User not found";
        break;
        case 409:
        errorMessage = "Email already registered";
        break;
        default:
        errorMessage =
        e.response?.data?.toString() ?? "Something went wrong";
        }
      }
      setState(() => result = errorMessage);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand mark
              FadeSlideIn(
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.sunsetGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'LocalBuzz',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              FadeSlideIn(
                delayMs: 80,
                child: Text(
                  'Welcome\nback.',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 10),
              FadeSlideIn(
                delayMs: 140,
                child: Text(
                  'Pick up where the neighborhood left off.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 32),

              // Role pills
              FadeSlideIn(
                delayMs: 200,
                child: Text(
                  'I AM A',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8,
                ),
                itemCount: _roles.length,
                itemBuilder: (context, index) {
                  final r = _roles[index];
                  final selected = selectedRole == r.$1;

                  return BuzzChoiceChip(
                    label: r.$2,
                    icon: r.$3,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        selectedRole = r.$1;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              FadeSlideIn(
                delayMs: 280,
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.alternate_email_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delayMs: 320,
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 12),

              FadeSlideIn(
                delayMs: 360,
                child: BuzzGradientButton(
                  label: 'SIGN IN',
                  icon: Icons.arrow_forward_rounded,
                  loading: isLoading,
                  onPressed: isLoading ? null : login,
                ),
              ),

              if (result.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          result,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                    "New around here?  ",
                    style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Create account'),
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

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}