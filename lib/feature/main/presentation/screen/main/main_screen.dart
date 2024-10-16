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
import 'package:omborchi/feature/main/presentation/screen/main/widgets/sync_dialog.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../../core/custom/widgets/dialog/info_dialog.dart';
import '../../../../../core/modules/app_module.dart';
import '../../../../../core/utils/consants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainBloc _bloc = MainBloc(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  CategoryModel? selectedCategory;
  List<CategoryModel>? categoryList;
  bool isSyncDialogOpen = false; // Keep track of dialog state
  int currentNomer = 0;
  int currentNomerIndex = 1;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _bloc.add(GetCategories());
    _bloc.add(GetProductsByCategory(selectedIndex));
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void showSyncProgressDialog(BuildContext context) {
    if (!isSyncDialogOpen) {
      isSyncDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocBuilder<MainBloc, MainState>(
            bloc: _bloc,
            builder: (context, state) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${state.currentRepository ?? ''} sinxronlanmoqda... "
                        "(${state.currentRepositoryIndex ?? 0}/$syncedNumber)",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        backgroundColor: AppColors.paleBlue,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                        value: (state.syncProgress ?? 0) / 100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${state.syncProgress?.toInt() ?? 0}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  void hideSyncProgressDialog(BuildContext context) {
    if (isSyncDialogOpen) {
      isSyncDialogOpen = false;
      Navigator.of(context).pop();
    }
  }

  void showSyncDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SyncWarningDialog(
            title: "E'tibor bering!".tr,
            message:
                "Internetning holati yaxshi ekanligini tekshiring. Sinxronlash tugallanmaguncha bu oynani yopmang"
                    .tr,
            tables: const [
              "Kategoriya",
              "Xomashyo turi",
              "Xomashyo",
              "Tannarx",
              "Mahsulot",
            ],
            positiveText: "Boshlash".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: (values) {
              syncedNumber = values.length;
              _bloc.add(SyncAppEvent(values: values));
              closeDialog(context);
            },
            onNegativeTap: () {
              closeDialog(context);
            },
          );
        });
  }

  String? currentRepository;

  double? syncProgress;
  int syncedNumber = 0;

  int? currentRepositoryIndex;

  String? tempError;

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
            _scaffoldKey.currentState?.closeDrawer();
            if (index == -1) {
              showSyncDialog(context);
            } else if (index == 0) {
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
          },
        ),
        appBar: SearchAppBar(
          onTapCancel: () {
            _bloc.add(GetProductsByCategory(selectedIndex));
          },
          onTapRefresh: () {
            _bloc.add(GetLocalDataEvent(selectedIndex));
          },
          onTapLeading: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          onChanged: (value) {
            if (value.isEmpty) {
              _bloc.add(GetProductsByCategory(selectedIndex));
            } else {
              _bloc.add(GetProductById(removeNonDigits(value), selectedIndex));
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
                        nomer, eni, boyi, narxi, marja, selectedIndex));
                  },
                );
              },
            );
          },
        ),
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state.error != null) {
              if (tempError == state.error!) {
              } else {
                AppRes.showSnackBar(context, state.error!);
                tempError = state.error;
              }
            }
            if (state.currentRepository != null ||
                state.syncProgress != null ||
                state.currentRepositoryIndex != null) {
              setState(() {
                currentRepository = state.currentRepository;
                syncProgress = state.syncProgress;
                currentRepositoryIndex = state.currentRepositoryIndex;
              }); // Trigger UI rebuild if loading state changes
            }
            if (state.isLoading) {
              showSyncProgressDialog(context);
            } else {
              hideSyncProgressDialog(context);
            }

            if (state.categories.isNotEmpty) {
              categoryList = state.categories;
            }

            if (state.isOpenDialog) {
              showLoadingDialog(context);
            }

            if (state.isCloseDialog && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            if(state.products.isNotEmpty) {
              currentNomer = 0;
              currentNomerIndex = 0;
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
                          return CategoryWidget(
                            onTap: () {
                              setState(() {
                                selectedCategory = null;
                                selectedIndex = 0;
                                _bloc.add(GetProductsByCategory(0));
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
                                _bloc.add(GetProductsByCategory(category.id!));
                              });
                            },
                            isActive: selectedIndex == index,
                            name: category.name,
                            count: 900, // Replace with actual count
                          );
                        }
                      },
                      itemCount: state.categories.length + 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const VerticalDivider(
                      color: Colors.grey, thickness: 1, width: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: state.isEmpty
                          ? Center(
                              child: Lottie.asset('assets/lottie/empty.json'),
                            )
                          : _buildProductGrid(state.products),
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

  void showDeleteDialog(BuildContext context, ProductModel product) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
            title: "O'chirish".tr,
            message: "Ushbu mahsulotni o'chirmoqchimisiz?".tr,
            positiveText: "O'chirish".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: () {
              _bloc.add(DeleteProduct(product, selectedIndex));
              closeDialog(context);
            },
            onNegativeTap: () {
              closeDialog(context);
            },
          );
        });
  }

  void showCustomPopover(BuildContext context, Widget child) {
    final overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox?;
    if (overlay != null) {
      final overlayEntry = OverlayEntry(
        builder: (_) => Positioned(
          top: 100, // Adjust accordingly
          left: 50, // Adjust accordingly
          child: Material(
            elevation: 4.0,
            child: child,
          ),
        ),
      );
      Overlay.of(context)?.insert(overlayEntry);
    }
  }

  Widget _buildProductGrid(List<ProductModel?> products) {
    if (products.isEmpty) {
      return Center(
        child: Lottie.asset('assets/lottie/empty.json'),
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
          return const SizedBox();
        }
        if (currentNomer == product.nomer) {
          currentNomerIndex++;
        } else {
          currentNomer = product.nomer;
          currentNomerIndex = 0;
        }

        var productNomer = "$currentNomer-$currentNomerIndex";
        if (productNomer.endsWith("-0")) {
          productNomer = productNomer.substring(0, productNomer.length - 2);
        }
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteManager.productViewScreen,
                arguments: product.copyWith(description: productNomer));
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
                      '#$productNomer',
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
