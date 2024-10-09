import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omborchi/core/custom/formatters/thousand_formatter.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/custom_text_field.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/category_dropdown.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/pick_image.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/raw_material_dropdown.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/raw_material_type_dropdown.dart';

import '../../../../../core/custom/widgets/floating_action_button.dart';
import '../../../../../core/custom/widgets/under_save_button.dart';
import '../../../domain/model/raw_material.dart';
import '../../../domain/model/raw_material_type.dart';

class RawMaterialItemData {
  final TextEditingController controller;
  RawMaterialType? selectedRawMaterialType;
  RawMaterial? selectedRawMaterial;

  RawMaterialItemData({
    required this.controller,
    this.selectedRawMaterialType,
    this.selectedRawMaterial,
  });
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AddProductBloc _bloc = serviceLocator<AddProductBloc>();
  XFile? image;
  final imagePicker = ImagePicker();
  final List<RawMaterialItemData> rawMaterialItems = [];

  final TextEditingController numberController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  Map<RawMaterialType, List<RawMaterial>>? rawMaterials;
  RawMaterialType? selectedRawMaterialType;
  RawMaterial? selectedRawMaterial;
  CategoryModel? selectedCategory;
  double productCost = 0.0;

  @override
  void initState() {
    super.initState();
    rawMaterialItems
        .add(RawMaterialItemData(controller: TextEditingController()));
    _bloc.add(GetCategories());
    _bloc.add(GetRawMaterialsWithTypes());
  }

  void _calculateTotalCost() {
    double totalCost = 0.0;

    // Har bir xomashyo elementining qiymatini umumiy tannarxga qo'shamiz
    for (var item in rawMaterialItems) {
      double quantity = double.tryParse(item.controller.text) ?? 0.0;
      if (item.selectedRawMaterial != null) {
        totalCost += quantity * (item.selectedRawMaterial?.price ?? 0.0);
      }
    }

    setState(() {
      productCost = totalCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: simpleAppBar(
        leadingIcon: AssetRes.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: "Maxsulot qo'shish".tr,
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<AddProductBloc, AddProductState>(
          listener: (context, state) {
            if (state.isSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Successfully added!"),
                behavior: SnackBarBehavior.floating,
              ));
              Navigator.pop(context);
            }

            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error!),
                behavior: SnackBarBehavior.floating,
              ));
            }
            if (state.rawMaterials != null) {
              rawMaterials = state.rawMaterials;
              setState(() {});
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Center(
                          child: PickedImage(
                            image: image,
                            onTap: () async {
                              image = await imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        _categorySelectorContainer(state),
                        const SizedBox(height: 16),
                        for (int i = 0; i < rawMaterialItems.length; i++)
                          Column(
                            children: [
                              addRawMaterialItem(
                                textController: rawMaterialItems[i].controller,
                                selectedRawMaterialType:
                                    rawMaterialItems[i].selectedRawMaterialType,
                                selectedRawMaterial:
                                    rawMaterialItems[i].selectedRawMaterial,
                                changedCost: (cost) {
                                  _calculateTotalCost();
                                },
                                onRawMaterialTypeChanged:
                                    (RawMaterialType? type) {
                                  setState(() {
                                    rawMaterialItems[i]
                                        .selectedRawMaterialType = type;
                                  });
                                },
                                onRawMaterialChanged: (RawMaterial? material) {
                                  setState(() {
                                    rawMaterialItems[i].selectedRawMaterial =
                                        material;
                                  });
                                  _calculateTotalCost();
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        productCostWidget(),
                        const SizedBox(height: 16),
                        curdRawMaterialButtons(
                          onTapPlus: () {
                            setState(() {
                              rawMaterialItems.add(RawMaterialItemData(
                                  controller: TextEditingController()));
                            });
                          },
                          onTapMinus: () {
                            setState(() {
                              if (rawMaterialItems.isNotEmpty) {
                                rawMaterialItems.removeLast();
                                _calculateTotalCost();
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
                UnderSaveButton(
                  title: "Qo'shish".tr,
                  onPressed: () {
                    _bloc.add(AddProduct(
                        productModel: ProductModel(
                            nomer: int.parse(numberController.text),
                            pathOfPicture: image?.path,
                            categoryId: selectedCategory?.id,
                            razmer:
                                "${heightController.text} ${widthController.text}",
                            isVerified: true)));
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _categorySelectorContainer(AddProductState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          dropDownWithTitle(
            "${"Kategoriya".tr} *",
            CategoryDropdown(
              hint: "Kategoriya tanlang",
              value: selectedCategory,
              buttonWidth: double.infinity,
              dropdownWidth: 200,
              dropdownItems: state.categories.toList(),
              itemColor: AppColors.background,
              buttonColor: AppColors.white,
              buttonTextStyle: medium.copyWith(fontSize: 16),
              itemTextStyle: medium.copyWith(fontSize: 16),
              onChanged: (value) {
                selectedCategory = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 16),
          TextWithTextFieldSmokeWhiteWidget(
            controller: numberController,
            textInputType: TextInputType.number,
            onChanged: (value) {},
            constraints: const BoxConstraints(maxHeight: 48),
            hint: "Nomer".tr,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextWithTextFieldSmokeWhiteWidget(
                  controller: heightController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {},
                  constraints: const BoxConstraints(maxHeight: 48),
                  hint: "Bo'yi".tr,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextWithTextFieldSmokeWhiteWidget(
                  controller: widthController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {},
                  constraints: const BoxConstraints(maxHeight: 48),
                  hint: "Eni".tr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget dropDownWithTitle(String title, Widget dropdown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: medium.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        dropdown
      ],
    );
  }
  Widget curdRawMaterialButtons(
      {required VoidCallback onTapPlus, required VoidCallback onTapMinus}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Row(
        children: [
          const Spacer(),
          primaryFloatingActionButton(onTap: onTapMinus, icon: Icons.remove),
          const SizedBox(
            width: 8,
          ),
          primaryFloatingActionButton(onTap: onTapPlus),
        ],
      ),
    );
  }
  Widget addRawMaterialItem({
    required TextEditingController textController,
    required Function(double value) changedCost,
    RawMaterialType? selectedRawMaterialType,
    RawMaterial? selectedRawMaterial,
    required Function(RawMaterialType?) onRawMaterialTypeChanged,
    required Function(RawMaterial?) onRawMaterialChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RawMaterialTypeDropdown(
                hint: "Turini tanlang",
                value: selectedRawMaterialType,
                itemColor: AppColors.background,
                buttonColor: AppColors.white,
                buttonTextStyle: medium.copyWith(fontSize: 16),
                itemTextStyle: medium.copyWith(fontSize: 16),
                dropdownItems: rawMaterials?.keys.toList() ?? [],
                onChanged: onRawMaterialTypeChanged,
              ),
              RawMaterialDropdown(
                hint: "Xomashyo tanlang",
                value: selectedRawMaterial,
                itemColor: AppColors.background,
                buttonColor: AppColors.white,
                buttonTextStyle: medium.copyWith(fontSize: 16),
                itemTextStyle: medium.copyWith(fontSize: 16),
                dropdownItems:
                    rawMaterials?[selectedRawMaterialType]?.toList() ?? [],
                onChanged: onRawMaterialChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextWithTextFieldSmokeWhiteWidget(
            controller: textController,
            textInputType: TextInputType.number,
            onChanged: (value) {
              double quantity = double.tryParse(formatNumber(value)) ?? 0.0;
              if (selectedRawMaterial != null) {
                double newCost = quantity * (selectedRawMaterial!.price ?? 0.0);
                changedCost(newCost);
              }
            },
            constraints: const BoxConstraints(maxHeight: 48),
            inputFormatters: [ThousandsSeparatorInputFormatter()],
            hint: "Soni".tr,
          ),
        ],
      ),
    );
  }

  Widget productCostWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tannarx",
            style: medium.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          Text(
            "${productCost.toStringAsFixed(2)} so'm",
            style: medium.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
