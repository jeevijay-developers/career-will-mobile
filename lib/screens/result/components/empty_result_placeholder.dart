import 'package:flutter/material.dart';

class EmptyResultPlaceholder extends StatelessWidget {
  const EmptyResultPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assessment_outlined, size: 80, color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            "Start typing to search results",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}
