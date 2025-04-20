import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart'; // For Lottie animation
import 'package:omborchi/config/router/app_routes.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/custom_button.dart';
import 'package:omborchi/core/custom/widgets/loading_dialog.dart';
import 'package:omborchi/core/custom/widgets/nav_bar.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
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
  bool isSyncDialogOpen = false;
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
          return PopScope(
            canPop: false, // Prevents back button from dismissing the dialog
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<MainBloc, MainState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${state.currentRepository ?? ''} sinxronlanmoqda... "
                          "(${state.currentRepositoryIndex ?? 0}/5)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Assuming pmedium
                            color: context.textColor(),
                          ),
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Assuming medium
                            color: context.textColor(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
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
            tables: const [],
            positiveText: "Boshlash".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: (values) {
              syncedNumber = 5;
              _bloc.add(SyncAppEvent(values: [
                "Kategoriya",
                "Xomashyo turi",
                "Xomashyo",
                "Tannarx",
                "Mahsulot",
              ]));
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
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: PrimaryNavbar(
          selectedIndex: 0,
          onItemTapped: (index) async {
            _scaffoldKey.currentState?.closeDrawer();
            if (index == -1) {
              showSyncDialog(context);
            } else if (index == 0) {
              Object? result = await Navigator.pushNamed(
                  context, RouteManager.addProductScreen);
              if (result == true) {
                AppRes.logger.t(
                    "message success added a product (category -)> $selectedIndex");
                _bloc.add(GetLocalDataEvent(selectedIndex));
              }
            } else if (index == 1) {
              Object? result = await Navigator.pushNamed(
                  context, RouteManager.categoryScreen);
              if (result == true) {
                _bloc.add(GetCategories());
              }
            } else if (index == 2) {
              Object? result = await Navigator.pushNamed(
                  context, RouteManager.rawMaterialScreen);
              if (result == true) {}
            } else if (index == 3) {
              Object? result = await Navigator.pushNamed(
                  context, RouteManager.rawMaterialTypeScreen);
              if (result == true) {}
            } else if (index == 4) {
              Object? result = await Navigator.pushNamed(
                  context, RouteManager.settingsScreen);
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
          onViewToggle: (isGrid) {
            setState(() => isGridView = isGrid);
          },
        ),
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state.error != null) {
              if (tempError == state.error!) {
              } else {
                AppRes.showSnackBar(context,
                    message: state.error!, isErrorMessage: true);
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
            if (state.products.isNotEmpty) {
              currentNomer = 0;
              currentNomerIndex = 0;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                                selectedIndex = category.id!;
                                _bloc.add(GetProductsByCategory(category.id!));
                              });
                            },
                            isActive: selectedIndex == category.id!,
                            name: category.name,
                            count: 900, // Replace with actual count
                          );
                        }
                      },
                      itemCount: state.categories.length + 1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const VerticalDivider(
                      color: Colors.grey, thickness: 1, width: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 6),
                      child: state.isEmpty
                          ? Center(
                              child: Lottie.asset('assets/lottie/empty.json'),
                            )
                          : isGridView
                              ? _buildProductGrid(state.products)
                              : _buildProductList(state.products),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          onPressed: _scrollToBottom,
          child: Icon(
            isBottom ? Icons.move_up_rounded : Icons.move_down_rounded,
            color: AppColors.white,
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      isBottom = false;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      isBottom = true;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    setState(() {});
  }

  bool isBottom = false;

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

  List<ProductModel> generateProductNumbers(List<ProductModel?> products) {
    final Map<String, int> nomerCounts = {};
    final List<ProductModel> updatedProducts = [];

    for (final product in products) {
      if (product == null) continue;

      final nomer = product.nomer.toString();
      if (nomerCounts.containsKey(nomer)) {
        nomerCounts[nomer] = nomerCounts[nomer]! + 1;
      } else {
        nomerCounts[nomer] = 0;
      }

      final index = nomerCounts[nomer]!;
      var productNomer = "$nomer-$index";
      if (productNomer.endsWith("-0")) {
        productNomer = productNomer.substring(0, productNomer.length - 2);
      }

      updatedProducts.add(product.copyWith(description: productNomer));
    }

    return updatedProducts;
  }

  Widget _buildProductList(List<ProductModel?> products) {
    final updatedProducts = generateProductNumbers(products);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      controller: _scrollController,
      itemCount: updatedProducts.length,
      itemBuilder: (context, index) {
        final product = updatedProducts[index];
        return CustomButton(
          child: ListTile(
            trailing: Text(
              '#${product.nomer}',
              style:
                  pregular.copyWith(color: context.textColor(), fontSize: 16),
            ),
            title: Text(
              'Marja: ${product.foyda} so\'m',
              style: pmedium.copyWith(color: context.textColor(), fontSize: 16),
            ),
            subtitle: Text(
              'Xizmat: ${product.xizmat} so\'m',
              style: pmedium.copyWith(color: context.textColor(), fontSize: 16),
            ),
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                RouteManager.productViewScreen,
                arguments: product,
              );
              if (result == true) {
                _bloc.add(GetLocalDataEvent(selectedIndex));
              }
            },
          ),
        );
      },
      separatorBuilder: (__, _) {
        return 8.verticalSpace;
      },
    );
  }

  Widget _buildProductGrid(List<ProductModel?> products) {
    if (products.isEmpty) {
      return Center(
        child: Lottie.asset('assets/lottie/empty.json'),
      );
    }

    final updatedProducts = generateProductNumbers(products);

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: updatedProducts.length,
      itemBuilder: (context, index) {
        final product = updatedProducts[index];
        return InkWell(
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              RouteManager.productViewScreen,
              arguments: product,
            );

            if (result == true) {
              _bloc.add(GetLocalDataEvent(selectedIndex));
            }
          },
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: context.containerColor(),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.pathOfPicture != null
                        ? !isValidUrl(product.pathOfPicture!)
                            ? Image.file(
                                File(product.pathOfPicture!),
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.error,
                                color: context.textColor(),
                              )
                        : Icon(
                            Icons.error,
                            color: context.textColor(),
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      color: AppColors.appBarDark.withAlpha(70),
                    ),
                    child: Text(
                      '#${product.description}',
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
