import 'dart:async';

import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/home/component/home_appbar.dart';
import 'package:careerwill/screens/home/component/home_drawer.dart';
import 'package:careerwill/screens/home/component/parent_view.dart';
import 'package:careerwill/provider/home_provider.dart';
import 'package:careerwill/screens/result/components/teacher_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultSearchScreen extends StatefulWidget {
  const ResultSearchScreen({super.key});

  @override
  _ResultSearchScreenState createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
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

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    if (query.trim().isEmpty) {
      homeProvider.clearSearchResult(); // 👈 Create and call this function
    } else {
      homeProvider.searchResult(query);
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
          ? TeacherViewResult(
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
