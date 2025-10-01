import 'dart:developer';

import 'package:careerwill/models/kit.dart';
import 'package:careerwill/models/parent.dart';
import 'package:careerwill/screens/auth/login/teacher_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careerwill/models/student.dart';
import 'package:careerwill/provider/home_provider.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/home/component/student_detail.dart';

class ParentView extends StatefulWidget {
  const ParentView({super.key});

  @override
  State<ParentView> createState() => _ParentViewState();
}

class _ParentViewState extends State<ParentView> {
  late Future<void> _fetchFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loggedInUser = userProvider.getLoginUsr();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    if (loggedInUser != null && loggedInUser.students.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _fetchFuture = Future.wait(
            loggedInUser.students.map(
              (id) => homeProvider.fetchStudentById(id),
            ),
          );
        });
      });
    } else {
      _fetchFuture = Future.value();
    }
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

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loggedInUser = userProvider.getLoginUsr();

    return FutureBuilder(
      future: _fetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        // Only log in debug mode to improve performance
        assert(() {
          log("logged in user ---> $loggedInUser");
          return true;
        }());

        // Fake student for test-id login
        if (loggedInUser != null && loggedInUser.id == "test-id") {
          final fakeStudent = Student(
            id: "fake-student-1",
            name: "John Doe",
            phone: "9999999999",
            imageUrl: ImageModel(publicId: "", url: ""),
            kit: [
              KitItem(id: "1", name: "Bag", description: ""),
              KitItem(id: "2", name: "Books", description: ""),
            ],
            feeId: null,
            rollNo: 12345,
            parent: ParentModel(
              fatherName: "Mr. Doe",
              id: "",
              occupation: '',
              email: '',
              motherName: '',
              parentContact: '',
            ),
            previousSchoolName: "Test High School",
            medium: "English",
            category: "General",
            state: "Test State",
            city: "Test City",
            pinCode: "123456",
            permanentAddress: "123 Test Street, Test City",
            tShirtSize: "L",
            howDidYouHearAboutUs: "Advertisement",
            programmeName: "Test Programme",
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [_buildStudentCard(fakeStudent, context)],
          );
        }

        if (loggedInUser == null || loggedInUser.students.isEmpty) {
          return const Center(
            child: Text("No student data linked to this parent."),
          );
        }

        final studentList = homeProvider.parentStudents;

        if (studentList.isEmpty) {
          return const Center(
            child: Text("No students found for this parent."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: studentList.length,
          itemBuilder: (context, index) {
            return _buildStudentCard(studentList[index], context);
          },
        );
      },
    );
  }

  Widget _buildStudentCard(Student student, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDetailScreen(student: student),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: student.imageUrl.url.isNotEmpty
                        ? NetworkImage(student.imageUrl.url)
                        : null,
                    child: student.imageUrl.url.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("Roll No: ${student.rollNo}"),
              Text("Phone: ${student.phone}"),
              Text("Address: ${student.city}, ${student.state}"),
              Text("Father Name: ${student.parent?.fatherName ?? ''}"),
              const SizedBox(height: 12),
              const Text(
                "Kit Items:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...student.kit.map((item) => Text("• ${item.name}")),
            ],
          ),
        ),
      ),
    );
  }
}
