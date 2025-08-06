import 'package:careerwill/models/user.dart';
import 'package:careerwill/screens/auth/login/teacher_login.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/home/home.dart';
import 'package:careerwill/screens/result/result.dart';
import 'package:flutter/material.dart';

Widget buildHomeDrawer(
  BuildContext context,
  User user,
  UserProvider userProvider,
) {
  return Drawer(
    child: Column(
      children: [
        _buildHeader(user),
        _buildDrawerItem(Icons.search, "Search Student", () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        }),
        _buildDrawerItem(Icons.assessment_outlined, "View Results", () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ResultSearchScreen()),
          );
        }),
        // _buildDrawerItem(Icons.settings_outlined, "Settings", () {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Settings coming soon!")),
        //   );
        // }),
        const Spacer(),
        _buildDrawerItem(
          Icons.logout,
          "Logout",
          () => _confirmLogout(context, userProvider),
          iconColor: Colors.red,
          textColor: Colors.red,
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

Widget _buildHeader(User user) {
  return DrawerHeader(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.indigo.shade400, Colors.indigo.shade600],
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            user.username.isNotEmpty ? user.username[0].toUpperCase() : "?",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem(
  IconData icon,
  String title,
  VoidCallback onTap, {
  Color iconColor = Colors.black87,
  Color textColor = Colors.black87,
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: textColor,
      ),
    ),
    onTap: onTap,
  );
}

void _confirmLogout(BuildContext context, UserProvider userProvider) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Logout Confirmation"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await userProvider.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            );
          },
          child: const Text("Logout"),
        ),
      ],
    ),
  );
}
