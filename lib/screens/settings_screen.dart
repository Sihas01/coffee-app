import 'dart:io';

import 'package:coffee_app/screens/login_screen.dart';
import 'package:coffee_app/services/auth_service.dart';
import 'package:coffee_app/widget/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () async {
              Navigator.pop(context);
              final image = await _picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                setState(() => _profileImage = File(image.path));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: () async {
              Navigator.pop(context);
              final image = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                setState(() => _profileImage = File(image.path));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageOptions,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('asset/images/profile.jpg')
                                as ImageProvider,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "John Doe",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 27,
                right: 15,
                left: 15,
                bottom: 20,
              ),
              child: Column(
                children: [
                  SettingsCard(
                    title: "Change Name",
                    description: "You can change name and surname",
                    icon: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),

                  SettingsCard(
                    title: "Change Password",
                    description: "Change your password easily",
                    icon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  ),

                  SettingsCard(
                    title: "Change Email",
                    description: "You can Change your email",
                    icon: Icon(
                      Icons.mail_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  ),

                  SettingsCard(
                    title: "Change Mobile Number",
                    description: "Change your mobile number",
                    icon: Icon(
                      Icons.tablet_android,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  ),

                  SettingsCard(
                    title: "Change Date of Birth",
                    description: "Change your date of birth",
                    icon: Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  ),

                  SettingsCard(
                    title: "Change Language",
                    description: "Change your language here",
                    icon: Icon(
                      Icons.translate,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SettingsCard(
                      title: "Logout",
                      description: "Sign out from your account",
                      icon: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 25,
                      ),
                      onTap: () async {
                        // Show confirmation dialog
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: "Are you sure you want to logout?",
                          confirmBtnText: "Yes",
                          cancelBtnText: "No",
                          confirmBtnColor: Colors.red,
                          onConfirmBtnTap: () async {
                            // Logout user
                            await AuthService.logout();
                            
                            // Navigate to login screen
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute<void>(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false, 
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
