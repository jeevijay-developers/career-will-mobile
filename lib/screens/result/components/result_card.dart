import 'package:careerwill/screens/result/components/result_details.dart';
import 'package:flutter/material.dart';
import 'package:careerwill/models/results.dart';

class StudentResultList extends StatelessWidget {
  final List<Result> results;

  const StudentResultList({required this.results, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentResultDetailScreen(result: result),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(
                      Icons.assignment,
                      color: Colors.indigo,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.student,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Roll No: ${result.rollNo}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          result.subjects.isNotEmpty
                              ? "Test: ${result.subjects[0].name} | Marks: ${result.subjects[0].marks}"
                              : "No subjects",
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
