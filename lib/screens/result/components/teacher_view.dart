import 'dart:developer';

import 'package:careerwill/screens/result/components/empty_result_placeholder.dart';
import 'package:careerwill/screens/result/components/result_card.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:careerwill/provider/home_provider.dart';
import 'package:careerwill/screens/home/component/search_bar.dart';

class TeacherViewResult extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedStudentName;
  final Function(String) onSearchChanged;

  const TeacherViewResult({
    required this.searchController,
    required this.selectedStudentName,
    required this.onSearchChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        log("Filtered results count: ${homeProvider.filteredResults.length}");
        return Column(
          children: [
            Text(
              "Search Student result",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.indigo,
              ),
            ),
            SearchBar(controller: searchController, onChanged: onSearchChanged),

            if (homeProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),

            if (!homeProvider.isLoading)
              Expanded(
                child: homeProvider.filteredResults.isEmpty
                    ? const EmptyResultPlaceholder()
                    : StudentResultList(results: homeProvider.filteredResults),
              ),
          ],
        );
      },
    );
  }
}
