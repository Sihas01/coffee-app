import 'package:coffee_app/models/user_provider.dart';
import 'package:coffee_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomTopBar({super.key});

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(225);
}

class _CustomTopBarState extends State<CustomTopBar> {
  @override
  void initState() {
    super.initState();
    // Fetch profile if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userProfile = userProvider.userProfile;

    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 225,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      flexibleSpace: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset('asset/images/coffee.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 25, left: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "Hello, ${userProfile?.username ?? 'User'}",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Good Morning",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.dark_mode_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Provider.of<Themeprovider>(
                                context,
                                listen: false,
                              ).toggleTheme();
                            },
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadiusDirectional.circular(30),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search..',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
