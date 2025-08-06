class ParentModel {
  final String id;
  final String occupation;
  final String fatherName;
  final String email;
  final String motherName;
  final String parentContact;

  ParentModel({
    required this.id,
    required this.occupation,
    required this.fatherName,
    required this.email,
    required this.motherName,
    required this.parentContact
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      occupation:  json['occupation'] ?? '', 
      fatherName: json['fatherName'] ?? '', 
      motherName:  json['motherName'] ?? '', 
      parentContact: json['parentContact'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Parent(id: $id,, email: $email, occupation: $occupation, fatherName: $fatherName, motherName: $motherName, parentContact: $parentContact)';
  }
}
