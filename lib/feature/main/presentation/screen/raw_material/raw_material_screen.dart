import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/dialog/info_dialog.dart';
import 'package:omborchi/core/custom/widgets/dialog/text_field_dialog.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/presentation/bloc/raw_material/raw_material_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/widgets/raw_materail_page.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material/widgets/raw_material_app_bar.dart';

class RawMaterialScreen extends StatefulWidget {
  const RawMaterialScreen({super.key});

  @override
  State<RawMaterialScreen> createState() => _RawMaterialScreenState();
}

class _RawMaterialScreenState extends State<RawMaterialScreen> {
  final RawMaterialBloc _bloc = serviceLocator<RawMaterialBloc>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  String? dialogErrorText1;
  String? dialogErrorText2;

  @override
  void initState() {
    super.initState();

    _bloc.add(GetRawMaterialsWithTypes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<RawMaterialBloc, RawMaterialState>(
        listener: (context, state) {
          if (state.errorMsg != null) {
            AppRes.showSnackBar(context,message:  state.errorMsg!, isErrorMessage: true);
          }
        },
        builder: (context, state) {
          return DefaultTabController(
              length: state.rawMaterials.length,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: rawMaterialAppBar(
                    title: "Xomashyolar".tr,
                    onTapLeading: () {
                      Navigator.pop(context);
                    },
                    actions: [
                      IconButton(
                          onPressed: () {
                            _bloc.add(RefreshRawMaterials());
                          },
                          icon: SvgPicture.asset(
                            AssetRes.icSynchronization,
                            colorFilter: const ColorFilter.mode(
                                AppColors.white, BlendMode.srcIn),
                          ))
                    ],
                    tabs: state.rawMaterials.keys
                        .toList()
                        .map((e) => e.name)
                        .toList()),
                body: Column(
                  children: [
                    Container(
                      height: 32,
                      color: AppColors.splash,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Xomashyo".tr,
                            style: medium.copyWith(
                                fontSize: 16, color: context.textColor()),
                          ),
                          Text(
                            "Narx".tr,
                            style: medium.copyWith(
                                fontSize: 16, color: context.textColor()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        for (var typeKey in state.rawMaterials.keys)
                          RawMaterailPage(
                            listRawMaterials: state.rawMaterials[typeKey]!,
                            onTapFloatingAction: () {
                              showAddDialog(context, typeKey);
                            },
                            onDelete: (RawMaterial rawMaterial) {
                              showDeleteDialog(context, typeKey, rawMaterial);
                            },
                            onEdit: (RawMaterial rawMaterial) {
                              showEditDialog(context, typeKey, rawMaterial);
                            },
                          )
                      ]),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  void showDeleteDialog(
      BuildContext context, RawMaterialType type, RawMaterial rawMaterial) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
            title: "O'chirish".tr,
            message: "Ushbu xomashyoni o'chirmoqchimisiz?".tr,
            positiveText: "O'chirish".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: () {
              _bloc.add(DeleteRawMaterial(type, rawMaterial));
              closeDialog(context);
            },
            onNegativeTap: () {
              closeDialog(context);
            },
          );
        });
  }

  void showEditDialog(
      BuildContext context, RawMaterialType type, RawMaterial rawMaterial) {
    _nameController.text = rawMaterial.name!;
    _costController.text = rawMaterial.price.toString();
    dialogErrorText1 = null;
    dialogErrorText2 = null;
    showPrimaryDialog(
      context: context,
      onTapPositive: () {
        _bloc.add(UpdateRawMaterial(
          type,
          rawMaterial.copyWith(
            name: _nameController.text,
            price: double.parse(_costController.text),
          ),
        ));
      },
      onTapNegative: () {
        closeDialog(context);
      },
      title: "Xomashyo turi".tr,
      positiveButton: "O'zgartir".tr,
    );
  }

  void showAddDialog(BuildContext context, RawMaterialType rawMaterialType) {
    _nameController.clear();
    _costController.clear();

    showPrimaryDialog(
        context: context,
        onTapPositive: () {
          _bloc.add(CreateRawMaterial(
            _nameController.text,
            _costController.text,
            rawMaterialType,
          ));
        },
        onTapNegative: () {},
        title: 'Xomashyo'.tr,
        positiveButton: "Qo'shish".tr);
  }

  void showPrimaryDialog({
    required BuildContext context,
    required VoidCallback onTapPositive,
    required VoidCallback onTapNegative,
    required String title,
    required String positiveButton,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return TextFieldDialog(
              title: title,
              controller1: _nameController,
              controller2: _costController,
              errorText1: dialogErrorText1,
              errorText2: dialogErrorText2,
              positiveTitle: positiveButton,
              negativeTitle: 'Bekor qilish'.tr,
              onTapPositive: () {
                if (_nameController.text.isNotEmpty) {
                  dialogErrorText1 = null;
                }
                if (_costController.text.isNotEmpty) {
                  dialogErrorText2 = null;
                }
                if (_nameController.text.isEmpty) {
                  setState(() {
                    dialogErrorText1 = "Nom bo'sh".tr;
                  });
                }

                if (_costController.text.isEmpty) {
                  setState(() {
                    dialogErrorText2 = "Narx bo'sh".tr;
                  });
                }

                if (dialogErrorText1 != null || dialogErrorText2 != null) {
                  return;
                }

                closeDialog(context);
                onTapPositive();
              },
              onNegativeTap: () {
                closeDialog(context);
              },
              title2: 'Xomashyo narxi'.tr,
              title1: 'Xomashyo nomi'.tr,
              hint1: '6 tunuka'.tr,
              hint2: '1000',
            );
          },
        );
      },
    );
  }
}
