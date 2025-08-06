class Attendance {
  final String id;
  final String rollNo;
  final String name;
  final String inTime;
  final String outTime;
  final String lateArrival;
  final String earlyDeparture;
  final String workingHours;
  final String otDuration;
  final String presentStatus;
  final DateTime date;

  Attendance({
    required this.id,
    required this.rollNo,
    required this.name,
    required this.inTime,
    required this.outTime,
    required this.lateArrival,
    required this.earlyDeparture,
    required this.workingHours,
    required this.otDuration,
    required this.presentStatus,
    required this.date,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['_id'],
      rollNo: json['rollNo'],
      name: json['name'],
      inTime: json['inTime'],
      outTime: json['outTime'],
      lateArrival: json['lateArrival'],
      earlyDeparture: json['earlyDeparture'],
      workingHours: json['workingHours'],
      otDuration: json['otDuration'],
      presentStatus: json['presentStatus'],
      date: DateTime.parse(json['date']),
    );
  }
}
