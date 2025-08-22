import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/auth/login/parent_login.dart';
import 'package:flutter/material.dart';

AppBar buildHomeAppBar(
  BuildContext context,
  String username, [
  UserProvider? userProvider,
  bool hideLeading = false, // 👈 new param
]) {
  return AppBar(
    title: Text("Welcome, $username"),
    automaticallyImplyLeading: !hideLeading, // 👈 disables back arrow
    actions: [
      if (userProvider != null) // 👈 only for parent
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              await userProvider.logout();

              // Replace entire stack with LoginPage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const ParentLogin()),
                (_) => false,
              );
            }
          },
        ),
    ],
  );
}
