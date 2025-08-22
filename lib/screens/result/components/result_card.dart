import 'package:careerwill/screens/result/components/result_details.dart';
import 'package:flutter/material.dart';
import 'package:careerwill/models/results.dart';

class StudentResultList extends StatelessWidget {
  final List<Result> results;

  const StudentResultList({required this.results, super.key});

  @override
  Widget build(BuildContext context) {
    // Sort results by date (newest first)
    final sortedResults = [...results];
    sortedResults.sort((a, b) {
      final dateA = a.date != null ? DateTime.tryParse(a.date!) : null;
      final dateB = b.date != null ? DateTime.tryParse(b.date!) : null;

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA); // latest first
    });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: sortedResults.length,
      itemBuilder: (context, index) {
        final result = sortedResults[index];

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
                        // Student Name
                        Text(
                          result.student,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Roll No
                        Text(
                          "Roll No: ${result.rollNo}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Total Marks
                        Text(
                          result.subjects.isNotEmpty
                              ? "Total Marks: ${result.total}"
                              : "No subjects",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Rank & Percentile
                        Text(
                          "Rank: ${result.rank} • Percentile: ${result.percentile}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        // Date
                        if (result.date != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            "Date: ${result.date!.split('T').first}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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
