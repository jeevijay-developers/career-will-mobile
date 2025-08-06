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
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _fetchFuture = homeProvider.fetchAllStudents();
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

        if (loggedInUser == null || loggedInUser.students.isEmpty) {
          return const Center(
            child: Text("No student data linked to this parent."),
          );
        }

        final studentIds = loggedInUser.students
            .map((e) => e.toString())
            .toSet();
        final studentList = homeProvider.allStudents
            .where((student) => studentIds.contains(student.id.toString()))
            .toList();

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
              Text("Address: ${student.address}"),
              Text("Father Name: ${student.parent!.fatherName}"),
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
