import 'package:isar/isar.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
part 'category_entity.g.dart';

@Collection()
class CategoryEntity {
  Id id = Isar.autoIncrement;
  late String name;

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name,}';
  }

  CategoryModel toModel(DateTime dateTime) {
    return CategoryModel(id: id, name: name, updatedAt: dateTime,);
  }
}
