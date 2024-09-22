import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/app_bar.dart';
import 'package:omborchi/core/custom/widgets/dialog/text_field_dialog.dart';
import 'package:omborchi/core/custom/widgets/floating_action_button.dart';
import 'package:omborchi/core/custom/widgets/pop_up_menu.dart';
import 'package:omborchi/core/modules/app_module.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material_type.dart';
import 'package:omborchi/feature/main/presentation/bloc/raw_material_type/raw_material_type_bloc.dart';
import 'package:popover/popover.dart';

class RawMaterialTypeScreen extends StatefulWidget {
  const RawMaterialTypeScreen({super.key});

  @override
  State<RawMaterialTypeScreen> createState() => _RawMaterialTypeScreenState();
}

class _RawMaterialTypeScreenState extends State<RawMaterialTypeScreen> {
  final RawMaterialTypeBloc _bloc = RawMaterialTypeBloc(serviceLocator());
  String? dialogErrorText;
  final Completer<void> _refreshCompleter = Completer<void>();
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

    // Listen to the bloc's state and complete the completer when done
    _bloc.stream.listen((state) {
      if (state.isLoading != true && _refreshCompleter.isCompleted == false) {
        // Complete the refresh when the Bloc indicates refresh is done
        _refreshCompleter.complete();
        // Reset the completer for future refreshes
      }
    });
  }

  @override
  void dispose() {
    _refreshCompleter.complete();
    _typeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<RawMaterialTypeBloc, RawMaterialTypeState>(
        listener: (context, state) {},
        builder: (context, state) => RefreshIndicator(
          backgroundColor: AppColors.background,
          color: AppColors.primary,
          onRefresh: () async {
            _bloc.add(RefreshTypes());

            // Wait until the completer completes (when the refresh is done)
            return _refreshCompleter.future;
          },
          child: Scaffold(
  backgroundColor: AppColors.background,
  appBar: simpleAppBar(
      leadingIcon: AssetRes.icBack,
      onTapLeading: () {},
      title: 'Xomashyo turi'),
  floatingActionButton: primaryFloatingActionButton(onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return TextFieldDialog(
              title: 'Xomashyo turi'.tr,
              controller1: _typeNameController,
              errorText1: dialogErrorText,
              positiveTitle: 'Qo\'shish'.tr,
              negativeTitle: 'Bekor qilish'.tr,
              onTapPositive: () {
                if (_typeNameController.text.isEmpty) {
                  setState(() {
                    dialogErrorText = "Nom bo'sh";
                  });
                  return;
                }
                closeDialog(context);
                _bloc.add(CreateType(
                  RawMaterialType(name: _typeNameController.text),
                ));
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
  }),
  body: Padding(
    padding: const EdgeInsets.all(15.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(  // Use Container here to ensure the ListView is a RenderBox
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: ListView.separated(
          itemCount: state.types.length,
          itemBuilder: (context, index) {
            return rawMaterialTypeItem(
              context: context,
              name: state.types[index].name,
              onTap: () {
                AppRes.logger.wtf(context);
                showPopover(
                  context: context,
                  bodyBuilder: (context) => Container(
                    width: 50,
                    height: 40,
                    color: Colors.amber,
                  ),
                  direction: PopoverDirection.bottom,
                  backgroundColor: Colors.white,
                  arrowHeight: 0,
                  arrowWidth: 0,
                );
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
      ),
    );
  }

  Widget rawMaterialTypeItem(
      {required BuildContext context,
      required String name,
      required VoidCallback onTap}) {
    return TextButton(
      style: kButtonWhiteStyle.copyWith(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
        ),
      ),
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 10), // Qo'shimcha padding
        child: Text(
          name,
          style: bold, // Sizning stil classingiz
        ),
      ),
    );
  }

  _showPopOver({
    required BuildContext context,
  }) {
    {
      showPopover(
        context: context,
        bodyBuilder: (childContext) => PopUpMenu(
          actions: const [
            'Edit',
            'Delete',
          ],
          iconPaths: const [
            AssetRes.icEdit,
            AssetRes.icTrash,
          ],
          onPressed: (ind) {
            closeScreen(childContext);

            if (ind == 0) {
              // navigateToEditTransaction(transaction);
            } else if (ind == 1) {
              // _bloc.add(ClickDeleteTransaction(transaction));
            }
          },
        ),
        direction: PopoverDirection.bottom,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width / 2,
        arrowHeight: 0,
        arrowWidth: 0,
      );
    }
  }
}
