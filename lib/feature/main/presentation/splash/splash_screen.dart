import 'package:flutter/material.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/utils/main_status.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/repository/category_repository.dart';

import '../../data/repository_impl/category_repository_impl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CategoryRepository categoryRepository =
      CategoryRepositoryImpl(serviceLocator(), serviceLocator());

  final CategoryModel categoryModel =
      CategoryModel(id: 0, name: "Nj", updatedAt: DateTime.now(), status: MainStatus.add.name);

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
            onPressed: () {},
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Get',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
