class KitItem {
  final String id;
  final String name;
  final String description;

  KitItem({
    required this.id,
    required this.name,
    required this.description,
  });

  factory KitItem.fromJson(Map<String, dynamic> json) {
    return KitItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }



  String toString() {
    return 'kitItem(name: $name, description: $description, sId: $id)';
  }
}
