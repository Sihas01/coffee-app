import 'dart:convert';

import 'package:coffee_app/config/api_config.dart';
import 'package:coffee_app/screens/login_screen.dart';
import 'package:coffee_app/widget/label_text.dart';
import 'package:coffee_app/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final url = Uri.parse(ApiConfig.registerUrl);

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _usernameController.text.trim(),
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Connection timeout. Please check if the backend server is running.');
          },
        );

        if (response.statusCode == 201) {
          // Registration successful
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Registration successful! Please login to continue.",
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (context) => const LoginScreen(),
              ),
            );
          });
        } else {
          // Registration failed
          try {
            final errorData = jsonDecode(response.body);
            final errorMessage = errorData["detail"] ?? "Registration failed. Please try again.";
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: errorMessage,
            );
          } catch (e) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Registration failed. Please try again.",
            );
          }
        }
      } catch (e) {
        print('Error during registration: $e');
        String errorMessage = "Connection error. ";
        
        if (e.toString().contains('Failed host lookup') || 
            e.toString().contains('Failed to fetch') ||
            e.toString().contains('Connection refused')) {
          errorMessage += "Cannot reach the backend server at ${ApiConfig.baseUrl}. "
              "Please ensure:\n"
              "1. Backend server is running\n"
              "2. IP address is correct (currently: ${ApiConfig.baseUrl})\n"
              "3. Both devices are on the same network";
        } else if (e.toString().contains('timeout')) {
          errorMessage += "Connection timeout. The server may be slow or unreachable.";
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
                borderRadius: const BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.asset(
                  'asset/images/register.png',
                  fit: BoxFit.cover,
                ),
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
                            "Welcome,",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Create an account to start ordering your favorite coffee.",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: LableText(label: "Username"),
                          ),
                          TextWidget(
                            label: "username",
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username is required";
                              }
                              if (value.length < 3) {
                                return "Username must be at least 3 characters";
                              }
                              return null;
                            },
                          ),
                          LableText(label: "Email Address"),
                          TextWidget(
                            label: "email address",
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),

                          LableText(label: "Password"),
                          TextWidget(
                            label: "password",
                            isPassword: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.background,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
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
                                      child: Text('Register'),
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
                            "already have a account? ",
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
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Log In",
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
