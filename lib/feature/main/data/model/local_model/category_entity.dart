import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
part 'category_entity.g.dart';

@Collection()
class CategoryEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime updatedAt;
  late String status;

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name, updatedAt: $updatedAt, status: $status}';
  }

  CategoryModel toModel(DateTime dateTime) {
    return CategoryModel(name: name, updatedAt: updatedAt, status: status);
  }
}
