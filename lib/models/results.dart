class Result {
  final String id, student, father, batch;
  final int rollNo, total, rank;
  final List<Subjects> subjects;
  final String? date;
  final num percentile;

  Result({
    required this.id,
    required this.student,
    required this.father,
    required this.batch,
    required this.rollNo,
    required this.percentile,
    required this.total,
    required this.rank,
    required this.subjects,
    this.date,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json["_id"],
      student: json["student"],
      father: json["father"],
      batch: json["batch"],
      rollNo: json["rollNumber"],
      percentile: json["percentile"],
      total: json["total"],
      rank: json["rank"],
      subjects: List<Subjects>.from(
        (json["subjects"] ?? []).map((e) => Subjects.fromJson(e)),
      ),
      date: json["date"],
    );
  }
}

class Subjects {
  final String name;
  final int marks;

  Subjects({required this.name, required this.marks});

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(name: json["name"], marks: json["marks"]);
  }
}
