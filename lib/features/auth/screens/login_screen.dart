import 'package:dio/dio.dart';
import 'register_screen.dart';
import 'package:flutter/material.dart';
import 'package:localbuzz_app/features/navigation/main_screen.dart';
import '../../../core/storage/token_storage.dart';
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
  String result = '';

  Future<void> login() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Dio().post(
        'http://10.0.2.2:8081/users/login',
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
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
        MaterialPageRoute(
          builder: (_) => MainScreen(
            role: role,
          ),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
        ),
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
                e.response?.data?.toString() ??
                    "Something went wrong";
        }
      }

      setState(() {
        result = errorMessage;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );

    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalBuzz Login Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Login As',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'USER',
                  child: Text('User'),
                ),
                DropdownMenuItem(
                  value: 'OWNER',
                  child: Text('Business Owner'),
                ),
                DropdownMenuItem(
                  value: 'COMMUNITY_ADMIN',
                  child: Text('Community Admin'),
                ),
                DropdownMenuItem(
                  value: 'ADMIN',
                  child: Text('Admin'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('LOGIN'),
              ),
            ),
            const SizedBox(height: 20),

            if (result.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                ),
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
              child: const Text(
                "Don't have an account? Register",
              ),
            ),
          ],
        ),
      ),
    );
  }
}