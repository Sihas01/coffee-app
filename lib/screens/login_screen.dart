import 'dart:convert';

import 'package:coffee_app/config/api_config.dart';
import 'package:coffee_app/screens/register_screen.dart';
import 'package:coffee_app/screens/route_screen.dart';
import 'package:coffee_app/services/auth_service.dart';
import 'package:coffee_app/widget/label_text.dart';
import 'package:coffee_app/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final url = Uri.parse(ApiConfig.tokenUrl);

        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'username_or_email': _usernameController.text.trim(),
                'password': _passwordController.text,
              }),
            )
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw Exception(
                  'Connection timeout. Please check if the backend server is running.',
                );
              },
            );

        if (response.statusCode == 200) {
          // Login successful
          final data = jsonDecode(response.body);
          final token = data["access_token"];

          // Save token to local storage
          await AuthService.saveToken(token);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Login successful!",
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (context) => const RouteScreen()),
              (route) => false, 
            );
          });
        } else {
          // Login failed
          try {
            final errorData = jsonDecode(response.body);
            final errorMessage =
                errorData["detail"] ??
                "Login failed. Please check your credentials.";
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: errorMessage,
            );
          } catch (e) {
            QuickAlert.show(
              context: context, 
              type: QuickAlertType.error,
              text: "Login failed. Please check your credentials.",
            );
          }
        }
      } catch (e) {
        print('Error during login: $e');
        String errorMessage = "Connection error. ";

        if (e.toString().contains('Failed host lookup') ||
            e.toString().contains('Failed to fetch') ||
            e.toString().contains('Connection refused')) {
          errorMessage +=
              "Cannot reach the backend server at ${ApiConfig.baseUrl}. "
              "Please ensure:\n"
              "1. Backend server is running\n"
              "2. IP address is correct (currently: ${ApiConfig.baseUrl})\n"
              "3. Both devices are on the same network";
        } else if (e.toString().contains('timeout')) {
          errorMessage +=
              "Connection timeout. The server may be slow or unreachable.";
        } else {
          errorMessage += "Error: ${e.toString()}";
        }

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: errorMessage,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.4,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.asset('asset/images/login.png', fit: BoxFit.cover),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          LableText(label: "Username"),
                          TextWidget(
                            label: "Username",
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Username is required";
                              return null;
                            },
                          ),

                          LableText(label: "Password"),
                          TextWidget(
                            label: "Password",
                            isPassword: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Password is required";
                              if (value.length < 6)
                                return "Password must be at least 6 characters";
                              return null;
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.background,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text('Sign In'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New to here? ",
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              overlayColor: Colors.transparent,
                            ),

                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Register",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
