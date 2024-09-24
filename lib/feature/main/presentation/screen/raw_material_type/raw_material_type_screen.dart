import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/dialog/info_dialog.dart';
import 'package:omborchi/core/custom/widgets/dialog/text_field_dialog.dart';
import 'package:omborchi/core/custom/widgets/floating_action_button.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/presentation/bloc/raw_material_type/raw_material_type_bloc.dart';
import 'package:omborchi/feature/main/presentation/screen/raw_material_type/widget/type_item.dart';

class RawMaterialTypeScreen extends StatefulWidget {
  const RawMaterialTypeScreen({super.key});

  @override
  State<RawMaterialTypeScreen> createState() => _RawMaterialTypeScreenState();
}

class _RawMaterialTypeScreenState extends State<RawMaterialTypeScreen> {
  final RawMaterialTypeBloc _bloc = RawMaterialTypeBloc(serviceLocator());
  String? dialogErrorText;
  final TextEditingController _typeNameController = TextEditingController();

  _onNameChanged() {
    if (_typeNameController.value.toString().isNotEmpty) {
      setState(() {
        dialogErrorText = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _bloc.add(GetTypes());

    _typeNameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _typeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<RawMaterialTypeBloc, RawMaterialTypeState>(
        listener: (context, state) {
          AppRes.logger.wtf(state.toString());

          if (state.isCRUD == true) {
            _bloc.add(GetTypes());
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: simpleAppBar(
            leadingIcon: AssetRes.icBack,
            onTapLeading: () {},
            title: 'Xomashyo turi',
            actions: [AssetRes.icSynchronization],
            onTapAction: (p0) {
              if (p0 == 0) {
                _bloc.add(RefreshTypes());
              }
            },
          ),
          floatingActionButton: primaryFloatingActionButton(onTap: () {
            showAddDialog(context);
          }),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                // Use Container here to ensure the ListView is a RenderBox
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: ListView.separated(
                  itemCount: state.types.length,
                  shrinkWrap: true,
                  itemBuilder: (itemBuilderContext, index) {
                    return RawMaterialTypeItem(
                      name: state.types[index].name,
                      onTapEdit: () {
                        showEditDialog(
                            context: context, type: state.types[index]);
                      },
                      onTapDelete: () {
                        showDeleteDialog(context, state.types[index]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1,
                      color: AppColors.steelGrey.withOpacity(0.2),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, RawMaterialType type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
            title: "O'chirish".tr,
            message: "Ushbu typeni o'chirmoqchimisiz?".tr,
            positiveText: "O'chirish".tr,
            negativeText: "Bekor qilish",
            onPositiveTap: () {
              _bloc.add(DeleteType(type));
              closeDialog(context);
            },
            onNegativeTap: () {
              closeDialog(context);
            },
          );
        });
  }

  void showEditDialog(
      {required BuildContext context, required RawMaterialType type}) {
    _typeNameController.text = type.name;
    dialogErrorText = null;
    showPrimaryDialog(
      context: context,
      onTapPositive: () {
        _bloc.add(UpdateType(type.copyWith(name: _typeNameController.text)));
      },
      onTapNegative: () {
        closeDialog(context);
      },
      title: "Xomashyo turi".tr,
      positiveTitle: "O'zgartir".tr,
    );
  }

  void showAddDialog(BuildContext context) {
    _typeNameController.clear();
    dialogErrorText = null;
    showPrimaryDialog(
        context: context,
        onTapPositive: () {
          _bloc.add(CreateType(
            RawMaterialType(name: _typeNameController.text),
          ));
        },
        onTapNegative: () {
          closeDialog(context);
        },
        title: 'Xomashyo turi'.tr,
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
              controller1: _typeNameController,
              errorText1: dialogErrorText,
              positiveTitle: positiveTitle,
              negativeTitle: 'Bekor qilish'.tr,
              onTapPositive: () {
                if (_typeNameController.text.isEmpty) {
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
              hint1: 'Skotch'.tr,
              title1: 'Tur nomi'.tr,
            );
          },
        );
      },
    );
  }
}
