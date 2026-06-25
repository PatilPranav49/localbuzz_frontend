import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services/register_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
  TextEditingController();

  final RegisterService service =
  RegisterService();

  bool isLoading = false;

  String selectedRole = "USER";

  Future<void> register() async {

    if (nameController.text.trim().isEmpty) {
      showMessage("Enter your name");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showMessage("Enter email");
      return;
    }

    if (passwordController.text.isEmpty) {
      showMessage("Enter password");
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showMessage("Passwords do not match");
      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await service.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole,
      );

      if (!mounted) return;

      String message =
          "Registration Successful";

      if (selectedRole ==
          "COMMUNITY_ADMIN") {
        message =
        "Registration Successful.\n\n"
            "Your account is awaiting Admin approval.";
      }

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const LoginPage(),
        ),
      );

    } on DioException catch (e) {

      String message =
          "Something went wrong";

      switch (e.response?.statusCode) {

        case 409:
          message =
          "Email already registered";
          break;

        case 400:
          message =
              e.response?.data.toString() ??
                  "Invalid request";
          break;

        default:
          message =
              e.response?.data.toString() ??
                  "Something went wrong";
      }

      showMessage(message);

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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

    return Scaffold(

      appBar: AppBar(
        title: const Text("Register"),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration:
              const InputDecoration(
                labelText: "Name",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration:
              const InputDecoration(
                labelText: "Email",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
              passwordController,
              obscureText: true,
              decoration:
              const InputDecoration(
                labelText: "Password",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
              confirmPasswordController,
              obscureText: true,
              decoration:
              const InputDecoration(
                labelText:
                "Confirm Password",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration:
              const InputDecoration(
                labelText:
                "Register As",
                border:
                OutlineInputBorder(),
              ),
              items: const [

                DropdownMenuItem(
                  value: "USER",
                  child: Text("User"),
                ),

                DropdownMenuItem(
                  value: "OWNER",
                  child:
                  Text("Business Owner"),
                ),

                DropdownMenuItem(
                  value:
                  "COMMUNITY_ADMIN",
                  child: Text(
                      "Community Admin"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole =
                  value!;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                isLoading
                    ? null
                    : register,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                    "REGISTER"),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const LoginPage(),
                  ),
                );
              },
              child: const Text(
                "Already have an account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}