class User {
  final String id;
  final String email;
  final String role;
  final String token;
  final String username;
  final String phone;
  final List<String> students;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
    required this.username,
    required this.phone,
    required this.students,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"] ?? "",
    email: json["email"] ?? "",
    role: json["role"] ?? "parent", // fallback
    token: json["token"] ?? "",
    phone: json["phone"] ?? "",
    username: json["username"] ?? "",
    students:
        (json["students"] as List<dynamic>?)
            ?.map((student) {
              if (student is Map && student.containsKey("_id")) {
                return student["_id"].toString();
              } else if (student is String) {
                return student;
              } else {
                return "";
              }
            })
            .where((id) => id.isNotEmpty)
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "role": role,
    "token": token,
    "phone": phone,
    "username": username,
    "students": students,
  };
}
