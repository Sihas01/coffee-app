import 'package:coffee_app/widget/settings_card.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  CircleAvatar(
                    radius: 70, // Size of the circle
                    backgroundImage: AssetImage(
                      'asset/images/profile.jpg',
                    ), // or NetworkImage
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
              padding: const EdgeInsets.only(top: 27, right: 15, left: 15),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
