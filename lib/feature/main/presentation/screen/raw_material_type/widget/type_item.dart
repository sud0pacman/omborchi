import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/pop_up_menu.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:popover/popover.dart';

class RawMaterialTypeItem extends StatelessWidget {
  final String name;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;

  const RawMaterialTypeItem({
    super.key,
    required this.name,
    required this.onTapEdit,
    required this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: kButtonWhiteStyle.copyWith(
        backgroundColor: WidgetStateProperty.all(context.backgroundColor()),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        )),
      ),
      onPressed: () {
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
              // closeScreen(childContext);
              closeDialog(context);

              if (ind == 0) {
                onTapEdit();
              } else if (ind == 1) {
                onTapDelete();
              }
            },
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: context.containerColor(),
          width: MediaQuery.of(context).size.width / 2,
          arrowHeight: 0,
          arrowWidth: 0,
        );
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Text(
          name,
          style: bold.copyWith(
              color: context
                  .textColor()), // Assuming you have a 'bold' text style defined
        ),
      ),
    );
  }
}
