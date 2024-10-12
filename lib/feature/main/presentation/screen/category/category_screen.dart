import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/dialog/info_dialog.dart';
import 'package:omborchi/core/custom/widgets/dialog/text_field_dialog.dart';
import 'package:omborchi/core/custom/widgets/floating_action_button.dart';
import 'package:omborchi/core/custom/widgets/shimmer_loading.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/presentation/bloc/category/category_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/category/widgets/category_item.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryBloc _bloc = CategoryBloc(serviceLocator());
  String? dialogErrorText;
  final TextEditingController _nameController = TextEditingController();

  _onNameChanged() {
    if (_nameController.value.toString().isNotEmpty) {
      setState(() {
        dialogErrorText = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(GetCategories());
    _nameController.addListener(_onNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.errorMsg != null) {
            AppRes.showSnackBar(context, state.errorMsg!);
          }
        },
        builder: (context, state) {
          if (state.isLoading == true) {
            return Scaffold(
              appBar: simpleAppBar(
                leadingIcon: AssetRes.icBack,
                onTapLeading: () {
                  Navigator.pop(context, true);
                },
                title: 'Kategoriyalar'.tr,
              ),
              body: const ShimmerLoading(),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: simpleAppBar(
              leadingIcon: AssetRes.icBack,
              onTapLeading: () {
                Navigator.pop(context);
              },
              title: 'Kategoriyalar'.tr,
              actions: [AssetRes.icSynchronization],
              onTapAction: (p0) {
                if (p0 == 0) {
                  _bloc.add(RefreshCategories());
                }
              },
            ),
            floatingActionButton: primaryFloatingActionButton(onTap: () {
              showAddDialog(context);
            }),
            body: state.categories.isEmpty
                ? Center(
                    child: Lottie.asset('assets/lottie/empty.json'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      return CategoryItem(
                        name: state.categories[index].name,
                        onTapEdit: () {
                          showEditDialog(context, state.categories[index]);
                        },
                        onTapDelete: () {
                          showDeleteDialog(context, state.categories[index]);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: AppColors.steelGrey.withOpacity(0.2),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 6, // number of shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              title: Container(
                width: double.infinity,
                height: 20.0, // height of the text
                color: Colors.white, // shimmer effect for text
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, CategoryModel category) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
            title: "O'chirish".tr,
            message: "Ushbu kategoriyani o'chirmoqchimisiz?".tr,
            positiveText: "O'chirish".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: () {
              _bloc.add(DeleteCategory(category));
              closeDialog(context);
            },
            onNegativeTap: () {
              closeDialog(context);
            },
          );
        });
  }

  void showEditDialog(BuildContext context, CategoryModel category) {
    _nameController.text = category.name;
    dialogErrorText = null;
    showPrimaryDialog(
      context: context,
      onTapPositive: () {
        _bloc
            .add(UpdateCategory(category.copyWith(name: _nameController.text)));
      },
      onTapNegative: () {
        closeDialog(context);
      },
      title: "Kategoriya".tr,
      positiveTitle: "O'zgartir".tr,
    );
  }

  void showAddDialog(BuildContext context) {
    _nameController.clear();
    dialogErrorText = null;
    showPrimaryDialog(
        context: context,
        onTapPositive: () {
          _bloc.add(CreateCategory(
            CategoryModel(name: _nameController.text),
          ));
        },
        onTapNegative: () {
          closeDialog(context);
        },
        title: 'Kategoriya'.tr,
        positiveTitle: "Qo'shish".tr);
  }

  void showPrimaryDialog({
    required BuildContext context,
    required VoidCallback onTapPositive,
    required VoidCallback onTapNegative,
    required String title,
    required String positiveTitle,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return TextFieldDialog(
              title: title,
              controller1: _nameController,
              errorText1: dialogErrorText,
              positiveTitle: positiveTitle,
              negativeTitle: 'Bekor qilish'.tr,
              onTapPositive: () {
                if (_nameController.text.isEmpty) {
                  setState(() {
                    dialogErrorText = "Nom bo'sh";
                  });
                  return;
                }
                closeDialog(context);
                onTapPositive();
              },
              onNegativeTap: () {
                closeDialog(context);
              },
              hint1: 'Lasina'.tr,
              title1: 'Nomi'.tr,
            );
          },
        );
      },
    );
  }
}
