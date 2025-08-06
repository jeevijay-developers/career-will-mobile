import 'package:flutter/material.dart';
import 'package:careerwill/models/student.dart';
import 'package:careerwill/screens/home/component/student_detail.dart';

class StudentList extends StatelessWidget {
  final List<Student> students;

  const StudentList({required this.students, super.key});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(child: Text("No students found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StudentDetailScreen(student: student)),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade100,
                    backgroundImage: student.imageUrl.url.isNotEmpty
                        ? NetworkImage(student.imageUrl.url)
                        : null,
                    child: student.imageUrl.url.isEmpty
                        ? const Icon(Icons.person, color: Colors.indigo, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Roll No: ${student.rollNo}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          student.phone,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

