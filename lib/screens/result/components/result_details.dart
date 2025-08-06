import 'package:flutter/material.dart';
import 'package:careerwill/models/results.dart';

class StudentResultDetailScreen extends StatelessWidget {
  final Result result;

  const StudentResultDetailScreen({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    String capitalizeFirstLetter(String input) {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          capitalizeFirstLetter(result.student),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.indigo.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                _infoTile("👤 Student", capitalizeFirstLetter(result.student)),
                _infoTile("👨‍👧 Father", result.father),
                _infoTile("🆔 Roll No", result.rollNo.toString()),
                _infoTile("📚 Batch", result.batch),
                const SizedBox(height: 20),

                const Divider(thickness: 1.5),
                const Text(
                  "📖 Subject-wise Marks",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 10),

                ...result.subjects.map(
                  (subj) => ListTile(
                    dense: true,
                    title: Text(subj.name),
                    trailing: Text(
                      "${subj.marks}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),

                const Divider(thickness: 1.5),
                const SizedBox(height: 10),
                _highlightTile("📊 Total Marks", "${result.total}"),
                _highlightTile("🏅 Rank", "${result.rank}"),
                _highlightTile(
                  "📈 Percentile",
                  "${result.percentile.toStringAsFixed(2)}%",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}
