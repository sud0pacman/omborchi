import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // For Lottie animation
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/loading_dialog.dart';
import 'package:omborchi/core/custom/widgets/nav_bar.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/presentation/bloc/main/main_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/category_widget.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/home_app_bar.dart';
import 'package:omborchi/feature/main/presentation/screen/main/widgets/search_dialog.dart';

import '../../../../../core/modules/app_module.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainBloc _bloc = MainBloc(serviceLocator(), serviceLocator());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  CategoryModel? selectedCategory;
  List<CategoryModel>? categoryList;

  @override
  void initState() {
    super.initState();
    _bloc.add(GetCategories()); // Load categories when screen initializes
    _bloc.add(GetProductsByCategory(
        selectedIndex)); // Load categories when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: PrimaryNavbar(
          selectedIndex: 0,
          onItemTapped: (index) async {
            if (index == 0) {
              bool? result = await Navigator.pushNamed(
                  context, RouteManager.addProductScreen);
              if (result == true) {
                _bloc.add(GetProductsByCategory(selectedIndex));
              }
            } else if (index == 1) {
              bool? result = await Navigator.pushNamed(
                  context, RouteManager.categoryScreen);
              if (result == true) {
                _bloc.add(GetCategories());
              }
            } else if (index == 2) {
              bool? result = await Navigator.pushNamed(
                  context, RouteManager.rawMaterialScreen);
              if (result == true) {}
            } else if (index == 3) {
              bool? result = await Navigator.pushNamed(
                  context, RouteManager.rawMaterialTypeScreen);
              if (result == true) {}
            }

            _scaffoldKey.currentState?.closeDrawer();
          },
        ),
        appBar: SearchAppBar(
          onTapCancel: () {
            _bloc.add(GetProductsByCategory(selectedIndex));
          },
          onTapRefresh: () {
            _bloc.add(SyncProducts(selectedIndex));
          },
          onTapLeading: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          onChanged: (value) {
            if (value.isEmpty) {
              _bloc.add(GetProductsByCategory(selectedIndex));
            } else {
              _bloc.add(GetProductById(removeNonDigits(value)));
            }
          },
          onTapSearch: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SearchDialog(
                    categoryList: categoryList ?? [],
                    onSearchTap: (nomer, eni, boyi, narxi, marja, category) {
                      _bloc.add(GetProductsByQuery(
                          nomer, eni, boyi, narxi, marja, category?.id ?? 0));
                    },
                  );
                });
          },
        ),
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state.categories.isNotEmpty) {
              categoryList = state.categories;
            }
            if (state.isOpenDialog) {
              showLoadingDialog(context);
            }
            if (state.isCloseDialog && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, bottom: 16, top: 16, right: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First item is always "Umumiy"
                          return CategoryWidget(
                            onTap: () {
                              setState(() {
                                selectedCategory = null;
                                selectedIndex = 0;
                                _bloc.add(GetProductsByCategory(
                                    0));
                              });
                            },
                            isActive: selectedIndex == 0,
                            name: "Umumiy".tr,
                            count: 1780,
                          );
                        } else {
                          final category = state.categories[index - 1];
                          return CategoryWidget(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                                selectedIndex = index;
                                _bloc.add(GetProductsByCategory(
                                    category.id!)); // Load products by category
                              });
                            },
                            isActive: selectedIndex == index,
                            name: category.name,
                            count: 900, // Replace with actual count if needed
                          );
                        }
                      },
                      itemCount: state.categories.length + 1,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  // Separator line between categories and products
                  const VerticalDivider(
                    color: Colors.grey, // Adjust the color
                    thickness: 1,
                    width: 1,
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: state.isEmpty
                          ? Center(
                        child: Lottie.asset('assets/lottie/empty.json'), // Show Lottie animation when empty
                      )
                          : _buildProductGrid(state.products), // Ensure products are passed correctly
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel?> products) {
    if (products.isEmpty) {
      return Center(
        child: Lottie.asset('assets/lottie/empty.json'), // Show empty state animation
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        if (product == null) {
          return const SizedBox(); // Handle null product case gracefully
        }
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteManager.productViewScreen,
                arguments: product);
          },
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.paleBlue,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(product.pathOfPicture ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.steelGrey,
                    ),
                    child: Text(
                      '#${product.nomer}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
