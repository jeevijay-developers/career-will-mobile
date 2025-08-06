class FeeModel {
  final int studentRollNo;
  final int totalFees;
  final int discount;
  final int finalFees;
  final int paidAmount;
  final int pendingAmount;
  final String status;
  final String approvedBy;
  final List<SubmissionModel> submissions;

  FeeModel({
    required this.studentRollNo,
    required this.totalFees,
    required this.discount,
    required this.finalFees,
    required this.paidAmount,
    required this.pendingAmount,
    required this.status,
    required this.approvedBy,
    required this.submissions,
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      studentRollNo: json['studentRollNo'],
      totalFees: json['totalFees'],
      discount: json['discount'],
      finalFees: json['finalFees'],
      paidAmount: json['paidAmount'],
      pendingAmount: json['pendingAmount'],
      status: json['status'],
      approvedBy: json['approvedBy'],
      submissions: (json['submissions'] as List)
          .map((e) => SubmissionModel.fromJson(e))
          .toList(),
    );
  }
}

class SubmissionModel {
  final int amount;
  final String mode;
  final DateTime dateOfReceipt;

  SubmissionModel({
    required this.amount,
    required this.mode,
    required this.dateOfReceipt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      amount: json['amount'],
      mode: json['mode'],
      dateOfReceipt: DateTime.parse(json['dateOfReceipt']),
    );
  }
}
