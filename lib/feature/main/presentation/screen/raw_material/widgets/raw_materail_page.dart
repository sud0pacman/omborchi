import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/widgets/floating_action_button.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:omborchi/feature/main/domain/model/raw_material.dart';

class RawMaterailPage extends StatelessWidget {
  final List<RawMaterial> listRawMaterials;
  final VoidCallback onTapFloatingAction;
  const RawMaterailPage(
      {super.key,
      required this.listRawMaterials,
      required this.onTapFloatingAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          primaryFloatingActionButton(onTap: onTapFloatingAction),
      backgroundColor: AppColors.background,
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: listRawMaterials.length,
        itemBuilder: (context, index) {
          return ListTile(
            splashColor: ,
            onTap: () {},
            title: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      listRawMaterials[index].name!,
                      style: regular,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      listRawMaterials[index].price.toString(),
                      style: regular,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: AppColors.steelGrey.withOpacity(0.2),
        ),
      ),
    );
  }
}
