import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/functions/custom_functions.dart';
import 'package:omborchi/core/custom/widgets/pop_up_menu.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:popover/popover.dart';

class RawMaterialItem extends StatelessWidget {
  final String name;
  final String price;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;

  const RawMaterialItem(
      {super.key,
      required this.name,
      required this.price,
      required this.onTapEdit,
      required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showPopover(
          context: context,
          transition: PopoverTransition.other,
          bodyBuilder: (childContext) => PopUpMenu(
            actions: [
              'Edit'.tr,
              'Delete'.tr,
            ],
            iconPaths: const [
              AssetRes.icEdit,
              AssetRes.icTrash,
            ],
            onPressed: (ind) {
              closeDialog(context);

              if (ind == 0) {
                onTapEdit();
              } else if (ind == 1) {
                onTapDelete();
              }
            },
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: Colors.white,
          width: MediaQuery.of(context).size.width / 2,
          arrowHeight: 0,
          arrowWidth: 0,
          contentDxOffset: 100,
        );
      },
      title: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                name,
                style:
                    regular.copyWith(fontSize: 16, color: context.textColor()),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              )),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              flex: 1,
              child: Text(
                price.toString(),
                style:
                    regular.copyWith(fontSize: 16, color: context.textColor()),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
