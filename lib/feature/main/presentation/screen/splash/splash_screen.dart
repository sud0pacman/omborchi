import 'package:flutter/material.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/utils/main_status.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';

import '../../../data/repository_impl/category_repository_impl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CategoryRepository categoryRepository =
      CategoryRepositoryImpl(serviceLocator(),);

  List<CategoryModel> cts = [];

  final CategoryModel categoryModel = CategoryModel(
      name: "Nj", updatedAt: DateTime.now(),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              categoryRepository.createCategory(categoryModel);
            },
            child: const Text(
              'Add',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              categoryRepository.updateCategory(categoryModel.copyWith(id: 2, name: 'Naj'));
            },
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              categoryRepository.deleteCategory(categoryModel.copyWith(id: 1,));
            },
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              final res = await categoryRepository.getCategories();

              setState(() {
                cts = res.value;
              });
            },
            child: const Text(
              'Get',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),

          for(var i = 0; i < cts.length; i++)
            Text('${cts[i].name} ${cts[i].id}', style: const TextStyle(fontSize: 20, color: Colors.black)),
        ],
      ),
    );
  }
}
