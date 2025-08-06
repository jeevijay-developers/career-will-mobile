import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:careerwill/provider/home_provider.dart';
import 'package:careerwill/screens/home/component/search_bar.dart';
import 'package:careerwill/screens/home/component/empty_student_placeholder.dart';
import 'package:careerwill/screens/home/component/student_card.dart';

class TeacherView extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedStudentName;
  final Function(String) onSearchChanged;

  const TeacherView({
    required this.searchController,
    required this.selectedStudentName,
    required this.onSearchChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Column(
          children: [
            Text(
              "Search Student",
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
              if (selectedStudentName?.isNotEmpty == true)
                Expanded(
                  child: StudentList(students: homeProvider.filteredStudents),
                )
              else
                const Expanded(child: EmptyStudentPlaceholder()),
          ],
        );
      },
    );
  }
}
