import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/dialog/text_field_dialog.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
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
        listener: (context, state) {},
        builder: (context, state) {
          return DefaultTabController(
              length: state.rawMaterials.length,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.background,
                appBar: rawMaterialAppBar(
                    title: "Xomashyolar".tr,
                    onTapLeading: () {},
                    tabs: state.rawMaterials.keys
                        .toList()
                        .map((e) => e.name)
                        .toList()),
                body: Column(
                  children: [
                    Container(
                      height: 32,
                      color: AppColors.steelGrey.withOpacity(0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Xomashyo".tr, style: medium.copyWith(fontSize: 16),),
                          Text("Narx".tr, style: medium.copyWith(fontSize: 16),),
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
                              })
                      ]),
                    ),
                  ],
                ),
              ));
        },
      ),
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
                if (_nameController.text.isEmpty) {
                  setState(() {
                    dialogErrorText1 = "Nom bo'sh";
                  });
                }

                if (_costController.text.isEmpty) {
                  setState(() {
                    dialogErrorText2 = "Narxi bo'sh";
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
              title2: 'Xomashyo narxi',
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
