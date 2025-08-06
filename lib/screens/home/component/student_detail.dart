import 'package:careerwill/provider/home_provider.dart';
import 'package:careerwill/screens/attendance/attendance_screen.dart';
import 'package:careerwill/screens/fee/fee_screen.dart' hide Student;
import 'package:careerwill/screens/fee/provider/fee_provider.dart';
import 'package:careerwill/screens/result/components/result_details.dart';
import 'package:flutter/material.dart';
import 'package:careerwill/models/student.dart';
import 'package:provider/provider.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(student.name, style: theme.textTheme.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                student.imageUrl.url.isNotEmpty
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(student.imageUrl.url),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.indigo.shade100,
                        child: Text(
                          student.name.isNotEmpty
                              ? student.name[0].toUpperCase()
                              : "?",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                const SizedBox(height: 24),

                _buildCardSection(
                  children: [
                    _buildInfoRow(
                      "Father's Name",
                      student.parent?.fatherName ?? "-",
                    ),
                    _divider(),
                    _buildInfoRow("Roll No", student.rollNo.toString()),
                    _divider(),
                    _buildInfoRow("Phone", student.phone),
                    _divider(),
                    _buildInfoRow("Address", student.address),
                  ],
                ),

                const SizedBox(height: 20),

                _buildCardSection(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kit Items",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (student.kit.isNotEmpty)
                      ...student.kit.map(
                        (kit) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.blue,
                          ),
                          title: Text(
                            kit.name,
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            kit.description,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                    else
                      Text(
                        "No kit items assigned.",
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                ),

                const SizedBox(height: 28),

                _buildButton(
                  context: context,
                  label: "View Result",
                  onPressed: () async {
                    final provider = Provider.of<HomeProvider>(
                      context,
                      listen: false,
                    );
                    await provider.searchResult(student.rollNo.toString());

                    if (provider.filteredResults.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No results found for this student"),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentResultDetailScreen(
                          result: provider.filteredResults.first,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildButton(
                  context: context,
                  label: "View Attendance",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttendanceScreen(student: student),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildButton(
                  context: context,
                  label: "View Fee Details",
                  onPressed: () async {
                    final feeProvider = Provider.of<FeeProvider>(
                      context,
                      listen: false,
                    );

                    await feeProvider.fetchFeeByRollNumber(student.rollNo);

                    if (feeProvider.fee != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeeScreen(
                            student: student,
                            fee: feeProvider.fee!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            feeProvider.errorMessage ?? "Fee details not found",
                          ),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(crossAxisAlignment: crossAxisAlignment, children: children),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, color: Colors.grey),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.indigo,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
