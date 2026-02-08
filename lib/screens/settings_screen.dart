import 'dart:io';

import 'package:coffee_app/config/api_config.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:coffee_app/models/user_provider.dart';
import 'package:coffee_app/screens/login_screen.dart';
import 'package:coffee_app/services/auth_service.dart';
import 'package:coffee_app/services/user_service.dart';
import 'package:coffee_app/widget/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fetch profile if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.userProfile == null) {
        userProvider.fetchProfile();
      }
    });
  }

  Future<void> _updateProfileImage(File imageFile) async {
    setState(() => _isUploading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // 1. Upload image to backend
    final imagePath = await UserService.uploadImage(imageFile);
    
    if (imagePath != null) {
      // 2. Update user profile with the new image path
      final success = await UserService.updateProfile(profileImage: imagePath);
      
      if (success) {
        // 3. Refresh profile in provider
        await userProvider.fetchProfile();
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Profile image updated successfully!",
          );
        }
      } else {
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Failed to update profile image.",
          );
        }
      }
    } else {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to upload image.",
        );
      }
    }
    
    setState(() => _isUploading = false);
  }

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
                _updateProfileImage(File(image.path));
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
                _updateProfileImage(File(image.path));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userProfile = userProvider.userProfile;
    final isLoading = userProvider.isLoading && userProfile == null;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _isUploading ? null : _showImageOptions,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                              backgroundImage: userProfile?.profileImage != null
                                  ? NetworkImage(
                                      userProfile!.profileImage!.startsWith('http')
                                          ? userProfile!.profileImage!
                                          : '${ApiConfig.baseUrl}${userProfile!.profileImage!}'
                                    )
                                  : const AssetImage('asset/images/profile.jpg') as ImageProvider,
                            ),
                            if (_isUploading)
                              const CircularProgressIndicator(),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          userProfile?.username ?? "User",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      Text(
                        userProfile?.email ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
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
                          icon: const Icon(
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
                                // Clear user data
                                Provider.of<UserProvider>(context, listen: false).clearProfile();
                                
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
