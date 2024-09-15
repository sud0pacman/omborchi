class CategoryEntity {
  final int? id;
  final String name;
  final DateTime updatedAt;
  final String status;


  CategoryEntity(
      {this.id, required this.name, required this.updatedAt, required this.status});


  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'status': status,
    };
  }

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name, updatedAt: $updatedAt, status: $status}';
  }
}