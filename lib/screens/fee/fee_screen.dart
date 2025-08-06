import 'package:careerwill/models/feeModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:careerwill/models/student.dart';

class FeeScreen extends StatelessWidget {
  final Student student;
  final FeeModel fee;

  const FeeScreen({super.key, required this.student, required this.fee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
        title: const Text(
          "Fee Details",
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "Student Details",
              icon: Icons.person,
              children: [
                _detailRow("Name", student.name),
                _detailRow("Roll No", student.rollNo.toString()),
                _detailRow("Father Name", student.parent?.fatherName ?? "N/A"),
              ],
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Fee Summary",
              icon: Icons.receipt_long,
              children: [
                _detailRow("Total Fees", "₹${fee.totalFees}"),
                _detailRow("Discount", "₹${fee.discount}"),
                _detailRow("Final Fees", "₹${fee.finalFees}"),
                _detailRow(
                  "Pending Amount",
                  "₹${fee.pendingAmount}",
                  valueColor: fee.pendingAmount > 0 ? Colors.red : Colors.green,
                ),
                _detailRow("Approved By", fee.approvedBy),
                _detailRow("Status", fee.status),
              ],
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Submissions",
              icon: Icons.payment,
              children: fee.submissions.map((submission) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow(
                        "Amount",
                        "₹${submission.amount}",
                        valueColor: Colors.green.shade700,
                      ),
                      _detailRow("Mode", submission.mode),
                      _detailRow(
                        "Date",
                        DateFormat(
                          'dd MMM yyyy',
                        ).format(submission.dateOfReceipt),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.indigo.shade400),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 90, 89, 89),
              fontSize: 14.5,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
                color: valueColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
