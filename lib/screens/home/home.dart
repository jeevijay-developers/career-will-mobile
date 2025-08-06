import 'dart:async';

import 'package:careerwill/screens/home/component/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/home/component/home_drawer.dart';
import 'package:careerwill/screens/home/component/teacher_view.dart';
import 'package:careerwill/screens/home/component/parent_view.dart';
import 'package:careerwill/provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedStudentName;
  Timer? _debounce;

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        selectedStudentName = query;
      });

      Provider.of<HomeProvider>(context, listen: false).searchStudent(query);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(
        context,
        listen: false,
      ).getLoginUsr();
      debugPrint("Logged-in User Students: ${user?.students}");

      // 🔥 Only fetch students if role is parent
      if (user != null && user.role.toLowerCase() == "parent") {
        Provider.of<HomeProvider>(context, listen: false).fetchAllStudents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final loggedInUser = userProvider.getLoginUsr();

    if (loggedInUser == null) {
      return const Scaffold(body: Center(child: Text("No user logged in.")));
    }

    final isTeacher = loggedInUser.role.toLowerCase() == "teacher";
    final isParent = loggedInUser.role.toLowerCase() == "parent";

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildHomeAppBar(loggedInUser.username),
      drawer: buildHomeDrawer(context, loggedInUser, userProvider),
      body: isTeacher
          ? TeacherView(
              searchController: searchController,
              selectedStudentName: selectedStudentName,
              onSearchChanged: _onSearchChanged,
            )
          : isParent
          ? const ParentView()
          : const Center(child: Text("Unknown user role.")),
    );
  }
}
