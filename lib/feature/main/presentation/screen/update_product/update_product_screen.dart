import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:omborchi/core/custom/formatters/thousand_formatter.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/custom_text_field.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/data/model/local_model/raw_material_ui.dart';
import 'package:omborchi/feature/main/domain/model/category_model.dart';
import 'package:omborchi/feature/main/domain/model/product_model.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/category_dropdown.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/pick_image.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/raw_material_dropdown.dart';
import 'package:omborchi/feature/main/presentation/screen/add_product/widgets/raw_material_type_dropdown.dart';

import '../../../../../core/custom/widgets/floating_action_button.dart';
import '../../../../../core/custom/widgets/loading_dialog.dart';
import '../../../../../core/custom/widgets/under_save_button.dart';
import '../../../domain/model/cost_model.dart';
import '../../../domain/model/raw_material.dart';
import '../../../domain/model/raw_material_type.dart';
import '../../bloc/update_product/update_product_bloc.dart';
import '../add_product/add_product_screen.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductModel product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final UpdateProductBloc _bloc = serviceLocator<UpdateProductBloc>();
  XFile? image;
  final imagePicker = ImagePicker();
  final List<RawMaterialItemData> rawMaterialItems = [];

  final TextEditingController numberController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController benefitController = TextEditingController();
  Map<RawMaterialType, List<RawMaterial>>? rawMaterials;
  RawMaterialType? selectedRawMaterialType;
  RawMaterial? selectedRawMaterial;
  CategoryModel? selectedCategory;
  List<CategoryModel> categoriesList = [];
  double productCost = 0.0;
  double productMarketCost = 0.0;
  String? categoryErrorText;
  String? numberErrorText;
  String? heightErrorText;
  String? widthErrorText;
  String? benefitErrorText;
  String? serviceErrorText;
  bool isImageChanged = false;
  String? imageErrorText;

  List<RawMaterialUpdate>? uiMaterials;

  @override
  void initState() {
    _bloc.add(GetRawMaterialsWithTypes());
    _bloc.add(GetCategories());
    _bloc.add(GetProductMaterials(productId: widget.product.id ?? 0));

    var product = widget.product;
    image = XFile(product.pathOfPicture ?? "");
    numberController.text = widget.product.nomer.toString();
    widthController.text = product.eni.toString();
    heightController.text = product.boyi.toString();
    serviceController.text = product.xizmat.toString();
    benefitController.text = product.foyda.toString();
    super.initState();
  }

  @override
  void dispose() {
    numberController.dispose();
    heightController.dispose();
    widthController.dispose();
    serviceController.dispose();
    benefitController.dispose();
    for (var item in rawMaterialItems) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: simpleAppBar(
        leadingIcon: AssetRes.icBack,
        onTapLeading: () {
          Navigator.pop(context, true);
        },
        title: "Maxsulotni yangilash".tr,
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<UpdateProductBloc, UpdateProductState>(
          listener: (context, state) {
            if (state.isSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(Constants.successUpdated),
                behavior: SnackBarBehavior.floating,
              ));
              closeDialog(context);
              Navigator.pop(context, true);
            }
            if (state.isLoading == true) {
              showLoadingDialog(context);
            }
            if (state.error != null) {
              AppRes.showSnackBar(context, state.error!);
            }
            if (state.categories.isNotEmpty) {
              AppRes.logger.t(state.categories.length);
              categoriesList = state.categories;
              setState(() {});
              for (var category in state.categories) {
                if (category.id == widget.product.categoryId) {
                  setState(() {
                    selectedCategory = category;
                  });
                }
              }
            }
            if (state.uiMaterials.isNotEmpty) {
              uiMaterials = state.uiMaterials;
              for (var value in uiMaterials!) {
                productCost +=
                    ((value.rawMaterial?.price ?? 0) * (value.quantity ?? 0))
                        .toInt();
              }
              setState(() {
                productMarketCost = productCost;
                productMarketCost += serviceController.text.toIntOrZero();
                productMarketCost += benefitController.text.toIntOrZero();
              });
            }
            if (state.rawMaterials != null) {
              rawMaterials = state.rawMaterials;
              var now = DateTime(2024, 8, 19);
              rawMaterials!.keys
                  .toList()
                  .map((item) => item.copyWith(updatedAt: now));
              rawMaterials!.keys.toList().forEach((item) {
                print(item);
              });
              for (var value in uiMaterials!) {
                var cont = TextEditingController();
                cont.text = value.quantity.toString().toIntOrZero().toString();

                if (!rawMaterials!.containsKey(
                    value.rawMaterialType?.copyWith(updatedAt: now))) {
                  print('Error: ${value.rawMaterialType} mavjud emas.');
                  continue; // Agar topilmasa, o'tkazib yuboriladi.
                }

                rawMaterialItems.add(
                  RawMaterialItemData(
                    controller: cont,
                    selectedRawMaterialType: value.rawMaterialType,
                    selectedRawMaterial: value.rawMaterial,
                  ),
                );
              }

              setState(() {});
            }
          },
          builder: (context, state) {
            return Stack(children: [
              Column(
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
                                if (image != null) {
                                  imageErrorText = null;
                                  isImageChanged = true;
                                } else {
                                  isImageChanged = false;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          if (imageErrorText != null)
                            Align(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(imageErrorText!,
                                    textAlign: TextAlign.start,
                                    style: mediumTheme.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        color: AppColors.red,
                                        height: 1)),
                              ),
                            ),
                          const SizedBox(height: 32),
                          _categorySelectorContainer(state),
                          const SizedBox(height: 16),
                          for (int i = 0; i < rawMaterialItems.length; i++)
                            Column(
                              children: [
                                addRawMaterialItem(
                                  textController:
                                      rawMaterialItems[i].controller,
                                  selectedRawMaterialType: rawMaterialItems[i]
                                      .selectedRawMaterialType,
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
                                  onRawMaterialChanged:
                                      (RawMaterial? material) {
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
                          productCostWidget(
                              "Tannarx", productCost.toStringAsFixed(2)),
                          const SizedBox(height: 16),
                          _serviceContainer(),
                          const SizedBox(height: 16),
                          productCostWidget(
                              "Sotuv", productMarketCost.toStringAsFixed(2)),
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
                          const SizedBox(height: 132),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              UnderSaveButton(
                title: "Yangilash".tr,
                onPressed: () {
                  _validateInputs();
                },
              )
            ]);
          },
        ),
      ),
    );
  }

  Widget _serviceContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextWithTextFieldSmokeWhiteWidget(
                  controller: serviceController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      serviceErrorText = null;
                      _calculateMarketCost();
                    });
                  },
                  title: "Xizmat",
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  constraints: const BoxConstraints(maxHeight: 48),
                  hint: "Xizmat".tr,
                  errorText: serviceErrorText, // Error text maydoni
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextWithTextFieldSmokeWhiteWidget(
                  controller: benefitController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      benefitErrorText = null; // Clear error if there is input
                      _calculateMarketCost();
                    });
                  },
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  constraints: const BoxConstraints(maxHeight: 48),
                  hint: "Marja".tr,
                  title: "Marja",
                  errorText: benefitErrorText, // Remove individual error text
                ),
              ),
            ],
          ),
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
    String? errorText, // Add errorText here
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
          if (errorText != null) // Agar xatolik bo'lsa, xabarni ko'rsatamiz
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          TextWithTextFieldSmokeWhiteWidget(
            controller: textController,
            textInputType: TextInputType.number,
            errorText: errorText,
            onChanged: (value) {
              double quantity = convertToInt(value).toDouble();
              if (selectedRawMaterial != null) {
                double newCost = quantity * (selectedRawMaterial.price ?? 0.0);
                AppRes.logger
                    .w("${convertToInt(value).toDouble()} || $newCost");
                changedCost(newCost);
              }
            },
            constraints: const BoxConstraints(maxHeight: 48),
            inputFormatters: [
              ThousandsSeparatorInputFormatter(),
              LengthLimitingTextInputFormatter(9)
            ],
            hint: "Soni".tr,
          ),
        ],
      ),
    );
  }

  void _validateInputs() {
    setState(() {
      categoryErrorText =
          selectedCategory == null ? "Kategoriya tanlanmagan" : null;
      numberErrorText =
          numberController.text.isEmpty ? "Nomer to'ldirilmagan" : null;
      serviceErrorText =
          serviceController.text.isEmpty ? "Xizmat to'ldirilmagan" : null;
      benefitErrorText =
          benefitController.text.isEmpty ? "Foyda to'ldirilmagan" : null;
      heightErrorText =
          heightController.text.isEmpty ? "Bo'yi to'ldirilmagan" : null;
      widthErrorText =
          widthController.text.isEmpty ? "Eni to'ldirilmagan" : null;
      imageErrorText = image == null ? "Iltimos, rasm tanlang" : null;
    });

    if ([
      categoryErrorText,
      numberErrorText,
      serviceErrorText,
      benefitErrorText,
      heightErrorText,
      widthErrorText,
      imageErrorText
    ].every((element) => element == null)) {
      _submitProduct();
    }
  }

  void _calculateMarketCost() {
    double service = serviceController.text.toIntOrZero().toDouble();
    double benefit = benefitController.text.toIntOrZero().toDouble();
    setState(() {
      productMarketCost = productCost + service + benefit;
    });
  }

  void _calculateTotalCost() {
    double totalCost = 0.0;
    for (var item in rawMaterialItems) {
      double quantity = convertToInt(item.controller.text).toDouble();
      if (item.selectedRawMaterial != null) {
        totalCost += quantity * (item.selectedRawMaterial?.price ?? 0.0);
      }
    }

    setState(() {
      productCost = totalCost;
      productMarketCost = productCost +
          serviceController.text.toIntOrZero() +
          benefitController.text.toIntOrZero();
    });
  }

  Widget _categorySelectorContainer(UpdateProductState state) {
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
              dropdownItems: categoriesList,
              itemColor: AppColors.background,
              buttonColor: AppColors.white,
              buttonTextStyle: medium.copyWith(fontSize: 16),
              itemTextStyle: medium.copyWith(fontSize: 16),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  categoryErrorText =
                      null; // Tanlanganida error text olib tashlanadi
                });
              },
            ),
          ),
          if (categoryErrorText != null)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(categoryErrorText!,
                    textAlign: TextAlign.start,
                    style: mediumTheme.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: AppColors.red,
                        height: 1)),
              ),
            ),
          const SizedBox(height: 16),
          TextWithTextFieldSmokeWhiteWidget(
            controller: numberController,
            textInputType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                numberErrorText = null; // Input bo'lsa, xatolik olib tashlanadi
              });
            },
            constraints: const BoxConstraints(maxHeight: 48),
            hint: "Nomer".tr,
            title: "Nomer",
            errorText: numberErrorText, // Error text maydoni
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextWithTextFieldSmokeWhiteWidget(
                  controller: heightController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      heightErrorText = null; // Clear error if there is input
                    });
                  },
                  constraints: const BoxConstraints(maxHeight: 48),
                  hint: "Bo'yi".tr,
                  title: "Bo'yi",
                  errorText: heightErrorText, // Remove individual error text
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextWithTextFieldSmokeWhiteWidget(
                  controller: widthController,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widthErrorText = null; // Clear error if there is input
                    });
                  },
                  constraints: const BoxConstraints(maxHeight: 48),
                  hint: "Eni".tr,
                  title: "Eni",
                  errorText: widthErrorText, // Remove individual error text
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

  void _submitProduct() {
    List<CostModel> costModels = rawMaterialItems.map((item) {
      return CostModel(
        productId: selectedCategory?.id ?? 0,
        xomashyoId: item.selectedRawMaterial?.id ?? 0,
        quantity: item.controller.text.toIntOrZero(),
      );
    }).toList();

    _bloc.add(UpdateProduct(
      isImageChanged: isImageChanged,
      productModel: widget.product.copyWith(
        nomer: (numberController.text.toIntOrZero()),
        pathOfPicture:
            isImageChanged ? image?.path : widget.product.pathOfPicture,
        categoryId: selectedCategory?.id,
        xizmat: serviceController.text.toIntOrZero(),
        foyda: benefitController.text.toIntOrZero(),
        sotuv: productMarketCost.toInt(),
        boyi: heightController.text.toIntOrZero(),
        eni: widthController.text.toIntOrZero(),
        isVerified: true,
      ),
      costModels: costModels, // Send the gathered list
    ));
  }

  Widget productCostWidget(String title, String cost) {
    MoneyFormatter fmf = MoneyFormatter(amount: double.parse(cost));
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
            title,
            style: medium.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          Text(
            "${fmf.output.withoutFractionDigits} so'm",
            style: medium.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
