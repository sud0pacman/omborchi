import 'package:omborchi/feature/main/data/remote_data_source/model/category_network.dart';

class CategoryModel {
  final int? id;
  final String name;
  final DateTime updatedAt;
  final bool isVerfied;


  CategoryModel({
    this.id,
    required this.name,
    required this.updatedAt,
    this.isVerfied = false,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
    bool? isVerfied,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerfied: isVerfied ?? this.isVerfied,
    );
  }

  CategoryNetwork toNetwork() {
    return CategoryNetwork(
      id: id,
      name: name,
      updatedAt: updatedAt,
      isVerfied: isVerfied,
    );
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, updatedAt: $updatedAt, isVerfied: $isVerfied}';
  }

}