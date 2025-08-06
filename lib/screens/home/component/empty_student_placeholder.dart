import 'package:flutter/material.dart';

class EmptyStudentPlaceholder extends StatelessWidget {
  const EmptyStudentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.school_outlined, size: 80, color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            "Start typing to search students",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}
