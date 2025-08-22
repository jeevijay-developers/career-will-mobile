import 'package:careerwill/screens/result/components/result_card.dart';
import 'package:flutter/material.dart';
import 'package:careerwill/models/results.dart';

class StudentResultScreen extends StatelessWidget {
  final List<Result> results;

  const StudentResultScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Results"),
        centerTitle: true,
      ),
      body: results.isEmpty
          ? const Center(
              child: Text(
                "No results available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : StudentResultList(results: results),
    );
  }
}
